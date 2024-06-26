//
//  Untitled.swift
//  SwiftUI-Demo
//
//  Created by Phuoc Ngo on 6/23/24.
//

import Foundation
import CoreLocation

public struct City: Identifiable, Hashable {
    public var id: String { name }
    public var name: String
}

public extension City {
    static let gardenGrove = City(
        name: String(localized: "Garden Grove", bundle: .main, comment: "A city in OC.")
    )
    
    static let westminster = City(
        name: String(localized: "Westminster", bundle: .main, comment: "A city in OC.")
    )
    
    static let santaAna = City(
        name: String(localized: "Santa Ana", bundle: .main, comment: "A city in OC.")
    )
    
    static let all = [gardenGrove, westminster, santaAna]
    
    static func identified(by id: City.ID) -> City {
        guard let result = all.first(where: { $0.id == id }) else {
            fatalError("Unknown City ID: \(id)")
        }
        return result
    }
}

