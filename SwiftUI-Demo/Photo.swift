//
//  Photo.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/10/24.
//

// This file contains the Photo and PhotoResponse models.
// The Photo model represents a photo object with its properties.
// The PhotoResponse model represents the response from the API when fetching photos.

import Foundation

/*
    Photo
    - This model represents a photo object with its properties.
    - It includes the photo ID, title, description, URL, and user ID.
    - It conforms to the Codable, Identifiable, and Hashable protocols.
 */
struct Photo: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let url: String
    let user: Int

    // Implement the CodingKeys enum to map the JSON keys to the properties
    enum CodingKeys: String, CodingKey {
        case id, title, description, url, user
    }
    
    // Implement the Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement the Equatable protocol
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

/*
    PhotoResponse
    - This model represents the response from the API when fetching photos.
    - It includes a success flag, message, and an array of photos.
    - It conforms to the Codable protocol.
 */
struct PhotoResponse: Codable {
    let success: Bool
    let message: String
    let photos: [Photo]
}
