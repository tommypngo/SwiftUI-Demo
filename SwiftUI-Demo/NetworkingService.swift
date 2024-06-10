//
//  NetworkingService.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

import Foundation
import Combine

class NetworkingService {
    private let baseURL = "https://api.slingacademy.com/v1/sample-data"
    
    func fetchBlogPosts(offset: Int = 0, limit: Int = 20) -> AnyPublisher<BlogPostResponse, Error> {
        let url = URL(string: "\(baseURL)/blog-posts?offset=\(offset)&limit=\(limit)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: BlogPostResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
//    func fetchPhoto(offset: Int = 0, limit: Int = 20) -> AnyPublisher<PhotoResponse, Error> {
//        let url = URL(string: "\(baseURL)/photos?offset=\(offset)&limit=\(limit)")!
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { $0.data }
//            .decode(type: PhotoResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
    
    func fetchPhotos(offset: Int = 0, limit: Int = 20) -> AnyPublisher<PhotoResponse, Error> {
        let url = URL(string: "\(baseURL)/photos?offset=\(offset)&limit=\(limit)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PhotoResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchPhotosForBlogPost(blogPost: BlogPost, offset: Int = 0, limit: Int = 20) -> AnyPublisher<[Photo], Error> {
        fetchPhotos(offset: offset, limit: limit)
            .map { $0.photos }
            .eraseToAnyPublisher()
    }
}
