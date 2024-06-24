//
//  CitiesListView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/11/24.
//

import SwiftUI

struct CitiesListView: View {
    
    @State private var selection: Panel? = Panel.city("Garden Grove")
    @State private var path = NavigationPath()
    
    var body: some View {
//        NavigationView {
//            List {
//                NavigationLink(destination: AddressInfoView()) {
//                    Text("Garden Grove")
//                }
//                Text("Westminster")
//            }
//            .navigationTitle("Cities")
//        }
        NavigationSplitView {
            Sidebar(selection: $selection)
        } detail: {
            NavigationStack(path: $path) {
                AddressInfoView()
                //DetailColumn(selection: $selection, model: model)
            }
        }
//        .onChange(of: selection) { _ in
//            path.removeLast(path.count)
//        }
//        .environmentObject(accountStore)
//        #if os(macOS)
//        .frame(minWidth: 600, minHeight: 450)
//        #elseif os(iOS)
//        .onChange(of: scenePhase) { newValue in
//            // If this view becomes active, tell the Messages manager to display
//            // store messages in this window.
//            if newValue == .active {
//                StoreMessagesManager.shared.displayAction = displayStoreMessage
//            }
//        }
//        .onPreferenceChange(StoreMessagesDeferredPreferenceKey.self) { newValue in
//            StoreMessagesManager.shared.sensitiveViewIsPresented = newValue
//        }
//        .onOpenURL { url in
//            let urlLogger = Logger(subsystem: "com.example.apple-samplecode.Food-Truck", category: "url")
//            urlLogger.log("Received URL: \(url, privacy: .public)")
//            let order = "Order#\(url.lastPathComponent)"
//            var newPath = NavigationPath()
//            selection = Panel.truck
//            Task {
//                newPath.append(Panel.orders)
//                newPath.append(order)
//                path = newPath
//            }
//        }
//        #endif
    }
}

#Preview {
    CitiesListView()
}
