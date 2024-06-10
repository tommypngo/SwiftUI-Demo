//
//  Organization.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

import Foundation

class BlogPost: Codable, Identifiable, ObservableObject {

    let id: Int
    let title: String
    let description: String
    let photoUrl: String
    let contentHtml: String
    let contentText: String
    let category: String
    let createdAt: String
    let updatedAt: String
    @Published var photos: [Photo]? // Add this line

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case photoUrl = "photo_url"
        case contentHtml = "content_html"
        case contentText = "content_text"
        case category
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int, title: String, description: String, photoUrl: String, contentHtml: String, contentText: String, category: String, createdAt: String, updatedAt: String, photos: [Photo]? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.photoUrl = photoUrl
        self.contentHtml = contentHtml
        self.contentText = contentText
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.photos = photos
    }
}

struct BlogPostResponse: Codable {
    let success: Bool
    let totalBlogs: Int
    let message: String
    let offset: Int
    let limit: Int
    let blogs: [BlogPost]

    enum CodingKeys: String, CodingKey {
        case success
        case totalBlogs = "total_blogs"
        case message
        case offset
        case limit
        case blogs
    }
}
