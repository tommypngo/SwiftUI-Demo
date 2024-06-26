//
//  CitiView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/24/24.
//

import SwiftUI
@preconcurrency import CoreLocation

/// The view that displays street sweeping information about an address of city.
///
struct AddressView: View {
    var addressInfo: AddressInfo?
    
    @ObservedObject private var viewModel = AddressInfoViewModel()

    @State private var spot: LocationSpot = LocationSpot(
        name: String(localized: "Apple Park",
                     comment: "Apple's headquarters in California."),
        location: CLLocation(latitude: 37.3348, longitude: -122.0090),
        cameraDistance: 1100
    )
    
    @State private var attributionLink: URL?
    @State private var attributionLogo: URL?
    @State private var searchText = ""
    
    /// The body function.
    ///
    /// Display various information about the city and the address
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                // Mapview
                ZStack {
                    Text("Beautiful Map Goes Here")
                        .hidden()
                        .frame(height: 350)
                        .frame(maxWidth: .infinity)
                }
                .background(alignment: .bottom) {
                    StreetShowCaseView(spot: spot, topSafeAreaInset: 0)
                        .mask {
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .black.opacity(0.15), location: 0.1),
                                    .init(color: .black, location: 0.6),
                                    .init(color: .black, location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .padding(.top, -150)
                }
                .overlay(alignment: .bottomTrailing) {
                    //
                }
                
                
                // Information views
                VStack {
                    Group {
                        VStack(alignment: .leading) {
                            Text("Council Member")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(addressInfo?.councilMember ?? "John O'Neill")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Street Sweeping Days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(addressInfo?.streetSweepingDays ?? "1st & 3rd Wednesday")
                            Text("Not Today")
                                .font(.title2)
                                .foregroundStyle(.green)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Trash Pickup Day")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(addressInfo?.trashPickupDay ?? "Monday")
                            Text("Today")
                                .font(.title2)
                                .foregroundStyle(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.quaternary.opacity(0.5), 
                                in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding()
                
                
                // Other data sources
                VStack {
                    AsyncImage(url: attributionLogo) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .controlSize(.mini)
                    }
                    .frame(width: 20, height: 20)
                    
                    Link("Other data sources", destination: attributionLink ?? URL(string: "https://weather-data.apple.com/legal-attribution.html")!)
                }
                .font(.footnote)
            }
            .padding(.bottom)
        }
        .searchable(text: $searchText)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        .navigationTitle("Title")
        .onChange(of: searchText) {
            viewModel.fetchAddressInfo(query: searchText)
        }
        .onAppear {
            viewModel.requestCurrentLocation()
        }
        .task {
            // Check today is street sweeping day or pick up trash day.
        }
    }
}

//#Preview {
//    AddressView()
//}
