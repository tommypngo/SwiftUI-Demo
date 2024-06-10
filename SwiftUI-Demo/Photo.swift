//
//  Photo.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/10/24.
//

import Foundation

struct Photo: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let url: String
    let user: Int
    
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

struct PhotoResponse: Codable {
    let success: Bool
    let message: String
    let photos: [Photo]
}
