//
//  AddressInfoViewModel.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/11/24.
//

import SwiftUI
import Combine

enum AddressEndpoint: String {

    // Add case for blogPosts
    case info = "info"
}

class AddressInfoViewModel: ObservableObject {
    @Published var addressInfo: AddressInfo?
    private var cancellables = Set<AnyCancellable>()
    
    // Base URL for the API endpoint
    private let baseURL = "https://ggcity.org/maps/api/addresses"
    
    // Initialize NetworkingService object to fetch data
    private let networkingService = NetworkingService()
    
    func fetchAddressInfo(query: String) {
        
        let endpoint = "\(AddressEndpoint.info.rawValue)?q=\(query)"
        
        // Fetch blog posts from the API endpoint
        networkingService.fetch(urlString: baseURL, endpoint: endpoint)
            // Receive on the main thread to update UI
            .receive(on: DispatchQueue.main)

            // Sink to handle completion and response value
            .sink(receiveCompletion: { completion in

                // Handle completion result (failure or finished)
                switch completion {
                case .failure(let error):
                    print("Error fetching address: \(error)")
                case .finished:
                    break
                }
            },

            // Handle response value (BlogPostResponse)
            // and fetch photos for blog posts
            receiveValue: { [weak self] addressInfo in
                self?.addressInfo = addressInfo
            })

            // Store the subscription in the cancellables set to keep it alive
            .store(in: &cancellables)
        
//        networkingService.fetch(urlString: urlString, endpoint: endpoint, query: query)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    print("Error: \(error)")
//                case .finished:
//                    break
//                }
//            }, receiveValue: { addressInfo in
//                self.addressInfo = addressInfo
//            })
//            .store(in: &cancellables)
    }
}
