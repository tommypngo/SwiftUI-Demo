//
//  NewContentView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

// This file contains the BlogPostCell and NewContentView views.
// The BlogPostCell view represents a single blog post cell in the list.
// The NewContentView view represents the main view of the app, which contains a list of blog posts.

import SwiftUI

/*
    BlogPostCell
    - This view represents a single blog post cell in the list.
    - It displays the blog post title, category, photo, description, content, photos, and created date.
    - It includes a button to toggle between showing full content and limited content.
 */

struct BlogPostCell: View {
    // Initialize BlogPost object
    @ObservedObject var blogPost: BlogPost

    // State variable to toggle full content
    @State private var showFullContent: Bool = false

    // Update blog post with fetched photos
    var formattedCreatedAt: String {

        // Format the created at date
        let dateFormatter = DateFormatter()

        // Adjusted to match the input format
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        // Check if the date can be converted
        if let createdAtDate = dateFormatter.date(from: blogPost.createdAt) {

            // Adjusted to match the output format
            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a" // Example: "Mar 16, 2023 at 7:06 PM"

            // Return the formatted date
            return dateFormatter.string(from: createdAtDate)
        }

        // Return the original date if formatting fails
        return blogPost.createdAt
    }

    // Main view body
    var body: some View {

        // Display blog post content
        VStack(alignment: .leading, spacing: 10) {

            // Display blog post title
            Text(blogPost.title)
                .font(.title)
                .bold()

            // Display blog post category
            Text("Category: \(blogPost.category)")
                .font(.subheadline)
                .foregroundColor(.gray)

            // Display blog post photo and description
            if let photoURL = URL(string: blogPost.photoUrl) {

                // Display blog post photo with loading indicator
                // Use AsyncImage to load image asynchronously
                // Use ProgressView as a placeholder while loading
                AsyncImage(url: photoURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)

                // Display blog post description in a horizontal stack
                HStack {
                    Spacer()
                    Text(blogPost.description)
                        .font(.footnote)
                    Spacer()
                }
            }

             // Display blog post content text or HTML content as attributed string
            if let contentHTML = blogPost.contentHtml.data(using: .unicode),

                // Convert HTML content to attributed string
                let attributedString = try? NSAttributedString(data: contentHTML, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {

                // Display blog post content attributed string
                Text(attributedString.string)
                    .font(.body)
                    .padding(.top)
                    // Show limited lines or full content
                    .lineLimit(showFullContent ? nil : 5)
            } else {

                // Display blog post content text
                Text(blogPost.contentText)
                    .font(.body)
                    .padding(.top)
                    // Show limited lines or full content
                    .lineLimit(showFullContent ? nil : 5)
            }

            // Button to toggle full content
            Button(action: {
                showFullContent.toggle()
            }) {
                // Display button text
                HStack {
                    // Show "Show More" or "Show Less" based on the state
                    Text(showFullContent ? "Show Less" : "Show More")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 5)

            // Display blog post photos
            if !blogPost.photos.isEmpty {

                // Display photos count
                Text("Photos (\(blogPost.photos.count))")
                    .font(.headline)
                    .padding(.top)

                // Display photos horizontally
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(blogPost.photos) { photo in

                            // Display photo image with loading indicator
                            AsyncImage(url: URL(string: photo.url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                }
            }

            // Display blog post created at date
            Text("Created at: \(formattedCreatedAt)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top)
        }
        .padding()
    }
}

/*
    NewContentView
    - This view displays a list of blog posts using the BlogPostCell view.
    - It uses the BlogPostViewModel to fetch and manage the blog post data.
    - The view includes pull-to-refresh functionality to reload the data.
    - The data is loaded when the view appears.
 */

struct NewContentView: View {

    // Initialize BlogPostViewModel
    @ObservedObject private var viewModel = BlogPostViewModel()

    // Main view body
    var body: some View {
        // Use NavigationView to enable navigation bar
        NavigationView {
            // Display list of blog posts
            List(viewModel.blogPosts) { blogPost in
                // Display each blog post cell
                BlogPostCell(blogPost: blogPost)
            }
            // Add pull-to-refresh functionality
            .refreshable {
                // Refresh data when pulling down the list
                viewModel.loadData()
            }

            // Set navigation bar title
            .navigationBarTitle("Blog Posts")

            // Load data when view appears
            .onAppear(perform: {
                viewModel.loadData()
            })
        }
    }
}

// Preview the NewContentView
#Preview {
    NewContentView()
}

