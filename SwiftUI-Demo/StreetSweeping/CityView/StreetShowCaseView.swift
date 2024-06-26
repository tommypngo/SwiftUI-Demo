//
//  StreetShowCaseView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/24/24.
//

import SwiftUI
import CoreLocation

struct StreetShowCaseView: View {
    
    var spot: LocationSpot
    var topSafeAreaInset: Double
    var animated = true
    
    var body: some View {
        
        GeometryReader { proxy in
            TimelineView(.animation(paused: !animated)) { context in
                
                let seconds = context.date.timeIntervalSince1970
                let rotationPeriod = 240.0
                let headingDelta = seconds.percent(truncation: rotationPeriod)
                let pitchPeriod = 60.0
                let pitchDelta = seconds
                    .percent(truncation: pitchPeriod)
                    .symmetricEaseInOut()
                
                let viewWidthPercent = (350.0 ... 1000).percent(for: proxy.size.width)
                let distanceMultiplier = (1 - viewWidthPercent) * 0.5 + 1
                
                DetailedMapView(
                    location: spot.location,
                    distance: distanceMultiplier * spot.cameraDistance,
                    pitch: (50...60).value(percent: pitchDelta),
                    heading: 360 * headingDelta,
                    topSafeAreaInset: topSafeAreaInset
                )
            }
        }
    }
}


#Preview {
    StreetShowCaseView(spot: LocationSpot(
        name: String(localized: "Apple Park",
                     comment: "Apple's headquarters in California."),
        location: CLLocation(latitude: 37.335_690, longitude: -122.013_330),
        cameraDistance: 500
    ), topSafeAreaInset: 0)
}
