//
//  AddressInfoViewModel.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/11/24.
//

import SwiftUI
import Combine
import CoreLocation

enum AddressEndpoint: String {

    // Add case for blogPosts
    case info = "info"
}

class AddressInfoViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var addressInfo: AddressInfo?
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    
    // Base URL for the API endpoint
    private let baseURL = "https://ggcity.org/maps/api/addresses"
    
    // Initialize NetworkingService object to fetch data
    private let networkingService = NetworkingService()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    private func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() {
        DispatchQueue.global(qos: .userInitiated).async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            } else {
                self.requestWhenInUseAuthorization()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            // Location permissions granted, start updating location
            manager.startUpdatingLocation()
        case .denied:
            // Location permissions denied, handle accordingly
            break
        case .restricted:
            // Location permissions restricted, handle accordingly
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return }
        
        
        fetchAddressFromLocation(location: location) { [weak self] fullAddress in
            guard let self, let fullAddress else { return }
            self.fetchAddressInfo(query: fullAddress)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
    
    private func fetchAddressFromLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first {
                var addressComponents = [String]()
                
                if let number = placemark.subThoroughfare {
                    addressComponents.append(number)
                }

                if let street = placemark.thoroughfare {
                    addressComponents.append(street)
                }
                
                /*
                if let city = placemark.locality {
                    addressComponents.append(city)
                }

                if let state = placemark.administrativeArea {
                    addressComponents.append(state)
                }

                if let postalCode = placemark.postalCode {
                    addressComponents.append(postalCode)
                }

                if let country = placemark.country {
                    addressComponents.append(country)
                }
                 */

                let fullAddress = addressComponents.joined(separator: " ")
                completion(fullAddress)
            } else {
                completion(nil)
            }
        }
    }

    
    func fetchAddressInfo(query: String) {
        isLoading = true
        addressInfo = nil
        
        let endpoint = "\(AddressEndpoint.info.rawValue)?q=\(query)"

        // Fetch address info from the API endpoint
        networkingService.fetch(urlString: baseURL, endpoint: endpoint)
        
            // Receive on the main thread to update UI
            .receive(on: DispatchQueue.main)

            // Sink to handle completion and response value
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                // Handle completion result (failure or finished)
                switch completion {
                case .failure(let error):
                    print("Error fetching address: \(error)")
                case .finished:
                    break
                }
            },

            // Handle response value
            receiveValue: { [weak self] addressInfo in
                self?.addressInfo = addressInfo
            })

            // Store the subscription in the cancellables set to keep it alive
            .store(in: &cancellables)
    }
}
