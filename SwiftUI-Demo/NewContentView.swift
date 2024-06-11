//
//  NewContentView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

import SwiftUI

struct BlogPostCell: View {
    @ObservedObject var blogPost: BlogPost
    @State private var showFullContent: Bool = false
    
    var formattedCreatedAt: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS" // Adjusted to match the input format
        if let createdAtDate = dateFormatter.date(from: blogPost.createdAt) {
            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a" // Example: "Mar 16, 2023 at 7:06 PM"
            return dateFormatter.string(from: createdAtDate)
        }
        return blogPost.createdAt
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(blogPost.title)
                .font(.title)
                .bold()
            
            Text("Category: \(blogPost.category)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if let photoURL = URL(string: blogPost.photoUrl) {
                AsyncImage(url: photoURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                
                HStack {
                    Spacer()
                    Text(blogPost.description)
                        .font(.footnote)
                    Spacer()
                }
            }
            
            if let contentHTML = blogPost.contentHtml.data(using: .unicode),
               let attributedString = try? NSAttributedString(data: contentHTML, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                Text(attributedString.string)
                    .font(.body)
                    .padding(.top)
                    .lineLimit(showFullContent ? nil : 5) // Show limited lines or full content
            } else {
                Text(blogPost.contentText)
                    .font(.body)
                    .padding(.top)
                    .lineLimit(showFullContent ? nil : 5) // Show limited lines or full content
            }
            
            Button(action: {
                showFullContent.toggle()
            }) {
                HStack {
                    Text(showFullContent ? "Show Less" : "Show More")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 5)
            
            if !blogPost.photos.isEmpty {
                Text("Photos (\(blogPost.photos.count))")
                    .font(.headline)
                    .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(blogPost.photos) { photo in
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
            
            Text("Created at: \(formattedCreatedAt)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top)
        }
        .padding()
    }
}


struct NewContentView: View {
    @ObservedObject private var viewModel = BlogPostViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.blogPosts) { blogPost in
                BlogPostCell(blogPost: blogPost)
            }
            .refreshable {
                viewModel.loadData()
            }
            .navigationBarTitle("Blog Posts")
            .onAppear(perform: {
                viewModel.loadData()
            })
        }
    }
}


#Preview {
    NewContentView()
}

