//
//  NetworkingService.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

import Foundation
import Combine

enum Endpoint: String {
    case blogPosts = "blog-posts"
    case photos = "photos"
}

class NetworkingService {
    private let baseURL = "https://api.slingacademy.com/v1/sample-data"
    
    func fetch<T: Decodable>(endpoint: Endpoint, offset: Int = 0, limit: Int = 20) -> AnyPublisher<T, Error> {
        let url = URL(string: "\(baseURL)/\(endpoint.rawValue)?offset=\(offset)&limit=\(limit)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
