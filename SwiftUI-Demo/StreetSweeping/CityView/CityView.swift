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
    
    
    @ObservedObject private var viewModel = AddressInfoViewModel()
    
    private var addressInfo: AddressInfo? {
        return viewModel.addressInfo
    }
    
    private var spot: LocationSpot {
        let location = viewModel.addressInfo != nil ?
        CLLocation(latitude: Double(viewModel.addressInfo!.latitude) ?? 37.3348,
                   longitude: Double(viewModel.addressInfo!.longitude) ?? -122.0090) :
        CLLocation(latitude: 37.3348, longitude: -122.0090)
        
        return LocationSpot(
            name: String(localized: "Test Location",
                         comment: "Apple's headquarters in California."),
            location: location,
            cameraDistance: 200
        )
    }
    
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
                    if viewModel.addressInfo != nil {
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
                    } else if !viewModel.isLoading {
                        VStack {
                            Spacer()
                            Text("No address information available")
                                .foregroundColor(.secondary)
                                .padding() // Add padding for better spacing
                            Spacer()
                        }
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    }
                   
                }
                .overlay(alignment: .bottomTrailing) {
                    //
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView().padding()
                            Spacer()
                        }
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                    } else {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.requestCurrentLocation()
                                }) {
                                    Image(systemName: "location.circle.fill")
                                        .font(.title)
                                        .padding()
                                        .background(Color.primary.opacity(0.75))
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                }
                                .padding()
                            }
                        }
                    }
                }
                
                
                // Information views
                VStack {
                    Group {
                        VStack(alignment: .leading) {
                            Text("Council Member")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(addressInfo?.councilMember ?? "N/A")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Street Sweeping Days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(addressInfo?.streetSweepingDays ?? "N/A")
                            Text("Not Today")
                                .font(.title2)
                                .foregroundStyle(.green)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Trash Pickup Day")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(addressInfo?.trashPickupDay ?? "N/A")
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
        .navigationTitle(viewModel.addressInfo?.jurisdiction ?? "OC")
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
