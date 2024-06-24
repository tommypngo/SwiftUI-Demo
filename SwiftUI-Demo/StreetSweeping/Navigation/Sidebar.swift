//
//  SideBar.swift
//  SwiftUI-Demo
//
//  Created by Phuoc Ngo on 6/23/24.
//

import SwiftUI

/// An enum that represents the person's selection in the app's sidebar.
///
/// The `Panel` enum encodes the views the person can select in the sidebar, and hence appear in the detail view.
enum Panel: Hashable {
    /// The value for the ``CityView``.
    case city(City.ID)
}

struct Sidebar: View {
    /// The person's selection in the sidebar.
    ///
    /// This value is a binding, and the superview must pass in its value.
    @Binding var selection: Panel?
    
    /// The view body.
    ///
    /// The `Sidebar` view presents a `List` view, with a `NavigationLink` for each possible selection.
    var body: some View {
        List(selection: $selection) {

            Section("Cities") {
                ForEach(City.all) { city in
                    NavigationLink(value: Panel.city(city.id)) {
                        Label(city.name, systemImage: "building.2")
                    }
                    .listItemTint(.secondary)
                }
            }
        }
        .navigationTitle("OC Street Sweeping")
        #if os(macOS)
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        #endif
    }
}
