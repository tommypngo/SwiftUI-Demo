//
//  NewContentView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/9/24.
//

import SwiftUI

class PhotoLoader: ObservableObject {
    @Published private var imageCache = [String: UIImage]()

    func image(for url: String) -> UIImage? {
        return imageCache[url]
    }

    func loadImages(for photos: [Photo]?) {
        guard let photos = photos else { return }
        for photo in photos {
            if let url = URL(string: photo.url) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageCache[photo.url] = image
                        }
                    }
                }.resume()
            }
        }
    }
}

struct BlogPostCell: View {
    @ObservedObject var blogPost: BlogPost
    @State private var showFullContent: Bool = false
    @State private var photoLoadingAttempts = 0
    private let maxPhotoLoadingAttempts = 5
    @StateObject private var photoLoader = PhotoLoader()
    
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
            }
            
            Text(blogPost.title)
                .font(.title)
                .bold()
            
            Text(blogPost.description)
                .font(.body)
            
            Text("Category: \(blogPost.category)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Created at: \(formattedCreatedAt)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top)
            
            if let photos = blogPost.photos, !photos.isEmpty {
                Text("Photos (\(photos.count))")
                    .font(.headline)
                    .padding(.top)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(photos) { photo in
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
                
            } else if blogPost.photos == nil {
                ProgressView() // Show a loading indicator if photos are not loaded yet
                    .onAppear {
                        startPhotoLoadingTimer()
                    }
            } else {
                // Handle case when photos cannot be loaded
                Text("Photos cannot be loaded")
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
        }
        .padding()
        .onAppear {
            photoLoader.loadImages(for: blogPost.photos)
        }
    }
    
    private func startPhotoLoadingTimer() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            photoLoadingAttempts += 1
            if blogPost.photos == nil && photoLoadingAttempts < maxPhotoLoadingAttempts {
                // Reload the view
                photoLoadingAttempts += 1
            }
        }
    }
}


struct NewContentView: View {
    @ObservedObject private var viewModel = BlogPostViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.blogPosts) { blogPost in
                BlogPostCell(blogPost: blogPost)
            }
            .navigationBarTitle("Blog Posts")
        }
    }
}


#Preview {
    NewContentView()
}

