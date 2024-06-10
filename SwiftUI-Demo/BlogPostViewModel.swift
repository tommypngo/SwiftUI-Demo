//
//  BlogPostViewModel.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

import Foundation
import Combine

class BlogPostViewModel: ObservableObject {
    @Published var blogPosts: [BlogPost] = []
    private var cancellables: Set<AnyCancellable> = []
    private let networkingService = NetworkingService()
    
    init() {
        fetchBlogPosts()
    }
    
//    private func fetchBlogPosts() {
//        networkingService.fetchBlogPosts()
//            .receive(on: DispatchQueue.global(qos: .background))
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    print("Error fetching blog posts: \(error)")
//                case .finished:
//                    print("Fetched blog posts successfully")
//                }
//            }, receiveValue: { [weak self] blogPostResponse in
//                DispatchQueue.main.async {
//                    self?.blogPosts = blogPostResponse.blogs
//                    self?.fetchPhotosForBlogPosts()
//                }
//            })
//            .store(in: &cancellables)
//    }
    
    private func fetchBlogPosts() {
        networkingService.fetchBlogPosts()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching blog posts: \(error)")
                case .finished:
                    print("Fetched blog posts successfully")
                }
            }, receiveValue: { [weak self] blogPostResponse in
                DispatchQueue.main.async {
                    self?.blogPosts = blogPostResponse.blogs
                    self?.fetchPhotosForBlogPosts()
                }
            })
            .store(in: &cancellables)
    }
    
//    private func fetchPhotosForBlogPosts() {
//        var nextOffset = 0
//        
//        for index in blogPosts.indices {
//            let randomInt = Int.random(in: 2...10)
//            let blogPostId = blogPosts[index].id
//            
//            networkingService.fetchPhoto(offset: nextOffset, limit: randomInt)
//                .receive(on: DispatchQueue.global(qos: .background))
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .failure(let error):
//                        print("Error fetching photos for blog post \(blogPostId): \(error)")
//                    case .finished:
//                        print("Fetched photos for blog post \(blogPostId) successfully")
//                    }
//                }, receiveValue: { [weak self] photoResponse in
//                    DispatchQueue.main.async {
//                        self?.updateBlogPostPhotos(at: index, with: photoResponse.photos)
//                    }
//                })
//                .store(in: &cancellables)
//            
//            nextOffset += randomInt
//        }
//    }
    
    private func fetchPhotosForBlogPosts() {
        for index in blogPosts.indices {
            let randomInt = Int.random(in: 2...10)
            let blogPost = blogPosts[index]
            
            networkingService.fetchPhotosForBlogPost(blogPost: blogPost, offset: 0, limit: randomInt)
                .receive(on: DispatchQueue.global(qos: .background))
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching photos for blog post \(blogPost.id): \(error)")
                    case .finished:
                        print("Fetched photos for blog post \(blogPost.id) successfully")
                    }
                }, receiveValue: { photos in
                    DispatchQueue.main.async {
                        self.updateBlogPostPhotos(at: index, with: photos)
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    private func updateBlogPostPhotos(at index: Int, with photos: [Photo]) {
        if index < blogPosts.count {
            let blogPost = blogPosts[index]
            blogPost.photos = photos
            DispatchQueue.main.async {
                self.blogPosts[index] = blogPost
            }
        }
    }
}

