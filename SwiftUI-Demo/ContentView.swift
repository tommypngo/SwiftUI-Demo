//
//  ContentView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Ngo on 6/5/24.
//

import SwiftUI

/*
    {
     "login": "ggobi",
     "id": 423638,
     "node_id": "MDEyOk9yZ2FuaXphdGlvbjQyMzYzOA==",
     "url": "https://api.github.com/orgs/ggobi",
     "repos_url": "https://api.github.com/orgs/ggobi/repos",
     "events_url": "https://api.github.com/orgs/ggobi/events",
     "hooks_url": "https://api.github.com/orgs/ggobi/hooks",
     "issues_url": "https://api.github.com/orgs/ggobi/issues",
     "members_url": "https://api.github.com/orgs/ggobi/members{/member}",
     "public_members_url": "https://api.github.com/orgs/ggobi/public_members{/member}",
     "avatar_url": "https://avatars.githubusercontent.com/u/423638?v=4",
     "description": ""
   }
 */

struct Organization: Codable, Identifiable {
    let login: String
    let id: Int
    var avatarURL: String?
    let nodeID: String
    let url: String
    let reposURL: String
    let eventsURL: String
    let hooksURL: String
    let issuesURL: String
    let membersURL: String
    let publicMembersURL: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
        case nodeID = "node_id"
        case url
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case hooksURL = "hooks_url"
        case issuesURL = "issues_url"
        case membersURL = "members_url"
        case publicMembersURL = "public_members_url"
        case description
    }
}

struct OrganizationCell: View {
    let organization: Organization
    
    var body: some View {
        HStack {
            if let avatarURL = organization.avatarURL, let url = URL(string: avatarURL) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        Color.red // Placeholder for error
                    } else {
                        ProgressView()
                    }
                }
            }
            VStack(alignment: .leading) {
                Text(organization.login)
                    .font(.headline)
                if let description = organization.description, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                }
                if let url = URL(string: organization.url) {
                    Link("Visit Website", destination: url)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct CustomOrganizationCell: View {
    let organization: Organization
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
            HStack(spacing: 16) {
                if let avatarURL = organization.avatarURL, let url = URL(string: avatarURL) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else if phase.error != nil {
                            Color.red
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text(organization.login)
                        .font(.headline)
                    if let description = organization.description, !description.isEmpty {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    if let url = URL(string: organization.url) {
                        Link("Visit Website", destination: url)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

struct ContentView: View {
    @State private var organizations: [Organization] = []
    
    var body: some View {
        NavigationView {
            List(organizations) { organization in
                CustomOrganizationCell(organization: organization)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Hadley's Organizations")
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData() {
        guard let url = URL(string: "https://api.github.com/users/hadley/orgs") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server responded with an error")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Organization].self, from: data)
                DispatchQueue.main.async {
                    self.organizations = decodedData
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
        }
        
        dataTask.resume()
    }
}

//#Preview {
//    ContentView()
//}
