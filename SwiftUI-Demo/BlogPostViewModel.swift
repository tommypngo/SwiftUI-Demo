//
//  BlogPostViewModel.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/10/24.
//

// This file contains the BlogPost and BlogPostResponse models.
// The BlogPost model represents a blog post object with its properties.
// The BlogPostResponse model represents the response from the API when fetching blog posts.

import Foundation
import Combine


/*
    BlogPost
    - This model represents a blog post object with its properties.
    - It includes the blog post ID, title, description, photo URL, content HTML, content text, category, created at, and updated at.
    - It conforms to the Codable, Identifiable, and ObservableObject protocols.
 */
class BlogPostViewModel: ObservableObject {

    // Initialize BlogPost object with @Published property wrapper
    @Published var blogPosts: [BlogPost] = []

    // Initialize cancellables set to store Combine subscriptions
    private var cancellables: Set<AnyCancellable> = []

    // Initialize NetworkingService object to fetch data
    private let networkingService = NetworkingService()

    // Function to load data
    func loadData() {
        // Call function to fetch blog posts
        fetchBlogPosts()
    }

    // Function to fetch blog posts
    private func fetchBlogPosts() {

        // Fetch blog posts from the API endpoint
        networkingService.fetch(endpoint: .blogPosts)
            // Receive on the main thread to update UI
            .receive(on: DispatchQueue.main)

            // Sink to handle completion and response value
            .sink(receiveCompletion: { completion in

                // Handle completion result (failure or finished)
                switch completion {
                case .failure(let error):
                    print("Error fetching blog posts: \(error)")
                case .finished:
                    break
                }
            },

            // Handle response value (BlogPostResponse)
            // and fetch photos for blog posts
            receiveValue: { [weak self] (response: BlogPostResponse) in
                self?.fetchPhotosForBlogPosts(blogPosts: response.blogs)
            })

            // Store the subscription in the cancellables set to keep it alive
            .store(in: &cancellables)
    }

    // Function to fetch photos for blog posts and update the blog posts array
    private func fetchPhotosForBlogPosts(blogPosts: [BlogPost]) {
        var nextOffset = 0
        var updatedBlogPosts = blogPosts

        // Create a DispatchGroup to handle multiple asynchronous tasks
        let group = DispatchGroup()

        // Iterate through each blog post and fetch photos
        for index in updatedBlogPosts.indices {

            // Generate a random number between 2 and 10 for the photo limit
            let randomInt = Int.random(in: 2...10)

            // Get the blog post at the current index
            let blogPost = updatedBlogPosts[index]

            // Enter the DispatchGroup
            group.enter()

            // Fetch photos for the blog post from the API endpoint with offset and limit
            networkingService.fetch(endpoint: .photos, offset: nextOffset, limit: randomInt)

                // Receive on the main thread to update UI
                .receive(on: DispatchQueue.main)

                // Sink to handle completion and response value
                .sink(receiveCompletion: { completion in

                    // Handle completion result (failure or finished)
                    switch completion {
                    case .failure(let error):
                        print("Error fetching photos for blog post \(blogPost.id): \(error)")
                    case .finished:
                        print("Fetched photos for blog post \(blogPost.id) successfully")
                    }
                },

                // Handle response value (PhotoResponse)
                receiveValue: { (response: PhotoResponse) in

                    // Update the blog post with fetched photos
                    let updatedBlogPost = BlogPost(id: blogPost.id, title: blogPost.title, description: blogPost.description, photoUrl: blogPost.photoUrl, contentHtml: blogPost.contentHtml, contentText: blogPost.contentText, category: blogPost.category, createdAt: blogPost.createdAt, updatedAt: blogPost.updatedAt, photos: response.photos)

                    // Update the blog post in the array
                    updatedBlogPosts[index] = updatedBlogPost

                    // Leave the DispatchGroup
                    group.leave()
                })

                // Store the subscription in the cancellables set to keep it alive
                .store(in: &cancellables)

            // Update the next offset for the next blog post
            nextOffset += randomInt
        }

        // Notify the main queue when all tasks are completed
        group.notify(queue: .main) {

            // Update the blog posts array with fetched photos
            self.blogPosts = updatedBlogPosts
        }
    }
}
