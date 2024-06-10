import Foundation
import Combine

class BlogPostViewModel: ObservableObject {
    @Published var blogPosts: [BlogPost] = []
    private var cancellables: Set<AnyCancellable> = []
    private let networkingService = NetworkingService()
    
    func loadData() {
        fetchBlogPosts()
    }
    
    private func fetchBlogPosts() {
        networkingService.fetch(endpoint: .blogPosts)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching blog posts: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (response: BlogPostResponse) in
                self?.fetchPhotosForBlogPosts(blogPosts: response.blogs)
            })
            .store(in: &cancellables)
    }
    
    private func fetchPhotosForBlogPosts(blogPosts: [BlogPost]) {
        var nextOffset = 0
        var updatedBlogPosts = blogPosts
        let group = DispatchGroup()
        
        for index in updatedBlogPosts.indices {
            let randomInt = Int.random(in: 2...10)
            let blogPost = updatedBlogPosts[index]
        
            group.enter()
            networkingService.fetch(endpoint: .photos, offset: nextOffset, limit: randomInt)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching photos for blog post \(blogPost.id): \(error)")
                    case .finished:
                        print("Fetched photos for blog post \(blogPost.id) successfully")
                    }
                }, receiveValue: { (response: PhotoResponse) in
                    let updatedBlogPost = BlogPost(id: blogPost.id, title: blogPost.title, description: blogPost.description, photoUrl: blogPost.photoUrl, contentHtml: blogPost.contentHtml, contentText: blogPost.contentText, category: blogPost.category, createdAt: blogPost.createdAt, updatedAt: blogPost.updatedAt, photos: response.photos)
                    updatedBlogPosts[index] = updatedBlogPost
                    group.leave()
                })
                .store(in: &cancellables)
            
            nextOffset += randomInt
        }
        
        group.notify(queue: .main) {
            self.blogPosts = updatedBlogPosts
        }
    }
}
