//
//  CitiesListView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/11/24.
//

import SwiftUI

struct CitiesListView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AddressInfoView()) {
                    Text("Garden Grove")
                }
                Text("Westminster")
            }
            .navigationTitle("Cities")
        }
    }
}

#Preview {
    CitiesListView()
}
