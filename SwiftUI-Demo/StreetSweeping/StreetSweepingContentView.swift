//
//  StreetSweepingContentView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/11/24.
//

import SwiftUI
import MapKit
import CoreLocation

//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var streetSweepingDays: String?
//    private let locationManager = CLLocationManager()
//    private let geocoder = CLGeocoder()
//
//    override init() {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
//                if let placemark = placemarks?.first, let street = placemark.thoroughfare {
//                    self?.fetchStreetSweepingDays(for: street)
//                }
//            }
//        }
//    }
//
//    func fetchStreetSweepingDays(for street: String) {
//        let urlString = "https://ggcity.org/maps/api/addresses/info?q=\(street.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//               let streetSweepingDays = json["street_sweeping_days"] as? String {
//                DispatchQueue.main.async {
//                    self?.streetSweepingDays = streetSweepingDays
//                }
//            }
//        }.resume()
//    }
//}
//
//struct StreetSweepingContentView: View {
//    @ObservedObject var locationManager = LocationManager()
//
//    var body: some View {
//        VStack {
//            if let streetSweepingDays = locationManager.streetSweepingDays {
//                Text("Street Sweeping Days: \(streetSweepingDays)")
//            } else {
//                Text("Fetching street sweeping days...")
//            }
//        }.onAppear(perform: {
//            locationManager.fetchStreetSweepingDays(for: "9431 Dewey Dr")
//        })
//    }
//}

import SwiftUI
import MapKit

struct StreetSweepingContentView: View {
    
    @StateObject private var viewModel = AddressInfoViewModel()
    
    var body: some View {
        VStack {
            if let addressInfo = viewModel.addressInfo {
                Text("Street Sweeping Days: \(addressInfo.streetSweepingDays)")
                
                MapView(coordinate: addressInfo.coordinate)
                    .frame(height: 300)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchAddressInfo(query: "9431%20Dewey%20Dr")
        }
    }
    
//    @State private var addressInfo: AddressInfo? = nil
//    
//    var body: some View {
//        VStack {
//            if let addressInfo = addressInfo {
//                Text("Street Sweeping Days: \(addressInfo.streetSweepingDays)")
//                
//                MapView(coordinate: addressInfo.coordinate)
//                    .frame(height: 300)
//            } else {
//                Text("Loading...")
//            }
//        }
//        .onAppear {
//            fetchAddressInfo()
//        }
//    }
//    
//    func fetchAddressInfo() {
//        guard let url = URL(string: "https://ggcity.org/maps/api/addresses/info?q=9431%20Dewey%20Dr") else {
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                if let addressInfo = try? JSONDecoder().decode(AddressInfo.self, from: data) {
//                    DispatchQueue.main.async {
//                        self.addressInfo = addressInfo
//                    }
//                }
//            }
//        }.resume()
//    }
}

// Preview the StreetSweepingContentView
//#Preview {
//    StreetSweepingContentView()
//}
