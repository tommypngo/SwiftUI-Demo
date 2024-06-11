//
//  AddressInfo.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/11/24.
//

import Foundation
import CoreLocation

struct AddressInfo: Codable {
    let addressID: String
    let address: String
    let postalCity: String
    let jurisdiction: String
    let zipCode: String
    let pdDistrict: String
    let fdDistrict: String
    let councilDistrict: String
    let councilMember: String
    let parcelAtlasSheet: String
    let codeEnforcementOfficer: String
    let censusTract: String
    let collegeDistrict: String
    let elementarySchoolDistrict: String?
    let inSfha: String
    let sfhaZone: String
    let highSchoolDistrict: String?
    let parcelApn: String
    let unifiedSchoolDistrict: String
    let nearestFireStation: String
    let cdbgZone: String?
    let landUseDesignation: String
    let redevelopmentZone: String?
    let zoningZone: String
    let zoningDesignation: String
    let streetSweepingDays: String
    let trashPickupDay: String
    let stateAssemblyDistrict: String
    let stateCongressionalDistrict: String
    let stateSenateDistrict: String
    let nearestPark: String
    let longitude: String
    let latitude: String
    
    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case address
        case postalCity = "postal_city"
        case jurisdiction
        case zipCode = "zip_code"
        case pdDistrict = "pd_district"
        case fdDistrict = "fd_district"
        case councilDistrict = "council_district"
        case councilMember = "council_member"
        case parcelAtlasSheet = "parcel_atlas_sheet"
        case codeEnforcementOfficer = "code_enforcement_officer"
        case censusTract = "census_tract"
        case collegeDistrict = "college_district"
        case elementarySchoolDistrict = "elementary_school_district"
        case inSfha = "in_sfha"
        case sfhaZone = "sfha_zone"
        case highSchoolDistrict = "high_school_district"
        case parcelApn = "parcel_apn"
        case unifiedSchoolDistrict = "unified_school_district"
        case nearestFireStation = "nearest_fire_station"
        case cdbgZone = "cdbg_zone"
        case landUseDesignation = "land_use_designation"
        case redevelopmentZone = "redevelopment_zone"
        case zoningZone = "zoning_zone"
        case zoningDesignation = "zoning_designation"
        case streetSweepingDays = "street_sweeping_days"
        case trashPickupDay = "trash_pickup_day"
        case stateAssemblyDistrict = "state_assembly_district"
        case stateCongressionalDistrict = "state_congressional_district"
        case stateSenateDistrict = "state_senate_district"
        case nearestPark = "nearest_park"
        case longitude
        case latitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
    }
}
