//
//  Organization.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

// This file contains the BlogPost and BlogPostResponse models.
// The BlogPost model represents a blog post object with its properties.
// The BlogPostResponse model represents the response from the API when fetching blog posts.

import Foundation

/*
    BlogPost
    - This model represents a blog post object with its properties.
    - It includes the blog post ID, title, description, photo URL, content HTML, content text, category, created at, and updated at.
    - It conforms to the Codable, Identifiable, and ObservableObject protocols.
 */
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

    // Add a property for photos array
    // with @Published property wrapper
    @Published var photos: [Photo] = []

    // Implement the CodingKeys enum to map the JSON keys to the properties
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

    // Initialize the BlogPost object
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
        self.photos = photos ?? []
    }
}

/*

 */
struct BlogPostResponse: Codable {
    let success: Bool
    let totalBlogs: Int
    let message: String
    let offset: Int
    let limit: Int
    let blogs: [BlogPost]

    // Implement the CodingKeys enum to map the JSON keys to the properties
    enum CodingKeys: String, CodingKey {
        case success
        case totalBlogs = "total_blogs"
        case message
        case offset
        case limit
        case blogs
    }
}
