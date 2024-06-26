//
//  DetailedMapView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/24/24.
//

import SwiftUI
import MapKit

private typealias ViewControllerRepresentable = UIViewControllerRepresentable

struct DetailedMapView: ViewControllerRepresentable {
    typealias ViewController = UIViewController
    
    var location: CLLocation
    var distance: Double = 1000
    var pitch: Double = 0
    var heading: Double = 0
    var topSafeAreaInset: Double
    
    class Controller: ViewController {
        
        var mapView: MKMapView {
            guard let tempView = view as? MKMapView else {
                fatalError("View could not be cast as MapView.")
            }
            return tempView
        }
        
        override func loadView() {
            
            //
            let mapView = MKMapView()
            view = mapView
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            //
            let configuration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
            configuration.pointOfInterestFilter = .excludingAll
            configuration.showsTraffic = false
            mapView.preferredConfiguration = configuration
            mapView.isZoomEnabled = false
            mapView.isPitchEnabled = false
            mapView.isScrollEnabled = false
            mapView.isRotateEnabled = false
            mapView.showsCompass = false
        }
    }
    
    func makeUIViewController(context: Context) -> Controller {
        Controller()
    }
    
    func updateUIViewController(_ controller: Controller, context: Context) {
        update(controller: controller)
    }
    
    func update(controller: Controller) {
        controller.additionalSafeAreaInsets.top = topSafeAreaInset
        controller.mapView.camera = MKMapCamera(
            lookingAtCenter: location.coordinate,
            fromDistance: distance,
            pitch: pitch,
            heading: heading
        )
    }
}


#Preview {
    DetailedMapView(location: CLLocation(latitude: 37.335_690, longitude: -122.013_330),
                    topSafeAreaInset: 0)
}
