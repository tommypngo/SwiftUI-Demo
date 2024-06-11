//
//  StreetSweepingContentView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/11/24.
//

import CoreLocation
import SwiftUI
import MapKit

struct AddressInfoView: View {
    @StateObject private var viewModel = AddressInfoViewModel()
    @State private var searchText = ""

    var body: some View {
        VStack {
            SearchBar(text: $searchText, onSearch: viewModel.fetchAddressInfo)

            MapView(coordinate: viewModel.addressInfo?.coordinate ?? CLLocationCoordinate2D())
                .frame(height: 300)
                .overlay(
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
                )
            
            if viewModel.isLoading {
                Text("Loading...")
            } else if let addressInfo = viewModel.addressInfo {
                AddressInfoSection(addressInfo: addressInfo)
            } else {
                Text("No address information available")
                    .foregroundColor(.secondary)
            }
            

            Spacer()
        }
        .onAppear {
            viewModel.requestCurrentLocation()
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onSearch: (String) -> Void

    var body: some View {
        HStack {
            TextField("Enter street number and name only", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                onSearch(text)
            }) {
                Image(systemName: "magnifyingglass")
            }
            .padding(.trailing)
        }
    }
}

struct AddressInfoSection: View {
    let addressInfo: AddressInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Council Member: \(addressInfo.councilMember)")
            Text("Street Sweeping Days: \(addressInfo.streetSweepingDays)")
            Text("Trash Pickup Day: \(addressInfo.trashPickupDay)")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// Preview the StreetSweepingContentView
/*
 #Preview {
 AddressInfoView()
 }
 */
