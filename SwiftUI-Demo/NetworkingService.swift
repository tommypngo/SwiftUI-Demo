//
//  NetworkingService.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

// This file contains the NetworkingService class.
// The NetworkingService class is responsible for fetching data from the API.
// It includes a function to fetch data from a specific endpoint.

import Foundation
import Combine

/*
    Endpoint
    - This enum represents the different endpoints available in the API.
    - It includes cases for blog posts and photos.
 */
enum Endpoint: String {

    // Add case for blogPosts
    case blogPosts = "blog-posts"

    // Add a case for photos
    case photos = "photos"
}

/*
    NetworkingService
    - This class is responsible for fetching data from the API.
    - It includes a function to fetch data from a specific endpoint.
 */
class NetworkingService {

    // Base URL for the API endpoint
    private let baseURL = "https://api.slingacademy.com/v1/sample-data"

    // Function to fetch data from a specific endpoint
    func fetch<T: Decodable>(endpoint: Endpoint, offset: Int = 0, limit: Int = 20) -> AnyPublisher<T, Error> {

        // Construct the URL with the endpoint, offset, and limit
        let url = URL(string: "\(baseURL)/\(endpoint.rawValue)?offset=\(offset)&limit=\(limit)")!

        // Fetch the data from the URL using URLSession data task publisher
        return URLSession.shared.dataTaskPublisher(for: url)

            // Map the data to the data property
            .map { $0.data }

            // Decode the data using the JSONDecoder
            .decode(type: T.self, decoder: JSONDecoder())

            // Handle errors
            .eraseToAnyPublisher()
    }
}
