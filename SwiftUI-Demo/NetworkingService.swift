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
    NetworkingService
    - This class is responsible for fetching data from the API.
    - It includes a function to fetch data from a specific endpoint.
 */
class NetworkingService {

    // Base URL for the API endpoint
    private let baseURL = "https://api.slingacademy.com/v1/sample-data"

    // Function to fetch data from a specific endpoint
    func fetch<T: Decodable>(urlString: String? = nil, endpoint: String) -> AnyPublisher<T, Error> {
        

        // Construct the URL with the endpoint, offset, and limit
        let url = URL(string: "\(urlString ?? baseURL)/\(endpoint)")!

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
