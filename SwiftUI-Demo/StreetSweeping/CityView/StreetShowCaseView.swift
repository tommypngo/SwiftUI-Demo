//
//  StreetShowCaseView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/24/24.
//

import SwiftUI
import CoreLocation

public struct LocationSpot: Identifiable, Hashable {
    public var id: String { name }
    public var name: String
    public var location: CLLocation
    public var cameraDistance: Double = 1000
}

public struct City: Identifiable, Hashable {
    public var id: String { name }
    public var name: String
    public var parkingSpots: [LocationSpot]
}

struct StreetShowCaseView: View {
    
//    var spot: LocationSpot
//    var topSafeAreaInset: Double
    var animated = true
    
    var body: some View {
        
        TimelineView(.animation) { context in
            let value = secondsValue(for: context.date)
            Circle()
                .trim(from: 0, to: value)
                .stroke()
        }
        
//        GeometryReader { proxy in
//            
//            TimelineView(.everyMinute) { context in
//                Text(context.date.formatted())
//            }
//            
////            TimelineView(.animation(paused: !animated)) { context in
////                let seconds = context.date.timeIntervalSince1970
////                let rotationPeriod = 240.0
////                let headingDelta = seconds.percent(truncation: rotationPeriod)
////                let pitchPeriod = 60.0
////                let pitchDelta = seconds
////                    .percent(truncation: pitchPeriod)
////                    .symmetricEaseInOut()
////                
////                let viewWidthPercent = (350.0 ... 1000).percent(for: proxy.size.width)
////                let distanceMultiplier = (1 - viewWidthPercent) * 0.5 + 1
////                
////                DetailedMapView(
////                    location: spot.location,
////                    distance: distanceMultiplier * spot.cameraDistance,
////                    pitch: (50...60).value(percent: pitchDelta),
////                    heading: 360 * headingDelta,
////                    topSafeAreaInset: topSafeAreaInset
////                )
////            }
//        }
    }
    
    private func secondsValue(for date: Date) -> Double {
        let seconds = Calendar.current.component(.second, from: date)
        return Double(seconds) / 60
    }
}

#Preview {
    StreetShowCaseView()
}
