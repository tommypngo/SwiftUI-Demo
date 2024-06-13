//
//  StreetSweepingContentView.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/11/24.
//

import CoreLocation
import SwiftUI
import MapKit
import UserNotifications

// Define a consistent padding value for the edges
let hPadding: CGFloat = 16
let vPadding: CGFloat = 16

struct AddressInfoView: View {
    @StateObject private var viewModel = AddressInfoViewModel()
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    
    private let notificationDelegate: NotificationDelegate
    
    init() {
        self.notificationDelegate = NotificationDelegate()
        UNUserNotificationCenter.current().delegate = NotificationDelegate()
    }

    
    var body: some View {
        ScrollView {
            VStack {
                // Custom Back Button
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }) {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    Spacer()
                    
                    // Navigation Title
                    Text("Address Information")
                        .font(.headline)
                        .padding(.leading, -30) // Adjust the padding as needed
                    
                    Spacer()
                }
                .padding()
                
                
                
                SearchBar(text: $searchText, onSearch: viewModel.fetchAddressInfo)
                    .padding(.horizontal, 0)
                    .padding(.bottom, vPadding) // Add space below the SearchBar
                
                
                MapView(coordinate: viewModel.addressInfo?.coordinate ?? CLLocationCoordinate2D())
                    .frame(height: 300)
                    .cornerRadius(10) // Rounded corners for the map
                    .shadow(radius: 5) // Subtle shadow for depth
                    .padding(.horizontal, hPadding)
                    .padding(.bottom, vPadding) // Add space below the SearchBar
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.requestCurrentLocation()
                                }) {
                                    Image(systemName: "location.circle.fill")
                                        .font(.title)
                                        .padding()
                                        .background(Color.primary.opacity(0.75))
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                }
                                .padding()
                            }
                        }
                    )
                
                if viewModel.isLoading {
                    ProgressView() // Use a progress indicator instead of text
                        .padding(.bottom, vPadding) // Add space below the ProgressView
                } else if let addressInfo = viewModel.addressInfo {
                    AddressInfoSection(addressInfo: addressInfo)
                        .transition(.slide) // Smooth transition for content
                        .padding(.bottom, vPadding) // Add space below the AddressInfoSection
                } else {
                    Text("No address information available")
                        .foregroundColor(.secondary)
                        .padding() // Add padding for better spacing
                }
                
                Spacer()
            }
            .keyboardAwarePadding()
            .padding() // Padding around the VStack for better spacing
            .background(Color(.systemBackground)) // Adaptive background color
            .navigationBarTitle("") // Set the navigation bar title to an empty string
            .navigationBarHidden(true) // Hide the navigation bar
            .onAppear {
                viewModel.requestCurrentLocation()
                requestNotificationPermission()
                if let addressInfo = self.viewModel.addressInfo {
                    scheduleStreetSweepingDayCheck(for: addressInfo.streetSweepingDays)
                }
            }
            .onReceive(viewModel.$addressInfo) { addressInfo in
                if let addressInfo = addressInfo {
                    scheduleStreetSweepingDayCheck(for: addressInfo.streetSweepingDays)
                }
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleStreetSweepingDayCheck(for sweepingDays: String) {
        
        let isStreetSweepingDay = isStreetSweepingDay(sweepingDays: sweepingDays)
        
        let content = UNMutableNotificationContent()
        content.title = "Street Sweeping Day Check"
        content.body = isStreetSweepingDay
            ? "Today is a street sweeping day: \(sweepingDays)"
            : "Today is not a street sweeping day."
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "StreetSweepingDailyCheck"
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21 // Set the desired hour for the daily check (e.g., 1 AM)
        dateComponents.minute = 19
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "StreetSweepingDailyCheck", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            } else {
                print("Daily street sweeping check scheduled successfully")
            }
        }
    }
}



struct SearchBar: View {
    @Binding var text: String
    var onSearch: (String) -> Void
    
    var body: some View {
        HStack {
            TextField("Street number and name only", text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0.5)
                )
            
            Button(action: {
                onSearch(text)
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, hPadding)
    }
}


struct AddressInfoSection: View {
    let addressInfo: AddressInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Council Member:")
                .font(.headline)
                .foregroundColor(.primary)
            Text(addressInfo.councilMember)
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            Text("Street Sweeping Days:")
                .font(.headline)
                .foregroundColor(.primary)
            Text(addressInfo.streetSweepingDays)
                .font(.title2)
                .foregroundColor(.secondary)
            Text(isStreetSweepingDay(sweepingDays: addressInfo.streetSweepingDays) ? "Today" : "Not Today")
                .font(.title2)
                .foregroundColor(isStreetSweepingDay(sweepingDays: addressInfo.streetSweepingDays) ? .red : .green)
                .padding(.bottom)
//            Button(action: {
//                if isStreetSweepingDay(sweepingDays: addressInfo.streetSweepingDays) {
//                    scheduleNotification(for: addressInfo.streetSweepingDays)
//                }
//            }) {
//                Text("Set Alert")
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 8)
//                    .background(Color.blue)
//                    .cornerRadius(8)
//            }
//            .padding(.top)


            
            Text("Trash Pickup Day:")
                .font(.headline)
                .foregroundColor(.primary)
            Text(addressInfo.trashPickupDay)
                .font(.title2)
                .foregroundColor(.secondary)

        }
        .padding()
        .frame(maxWidth: .infinity) // Match the width with MapView
        .background(Color(.systemGroupedBackground)) // A grouped background color
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Subtle shadow for depth
        .padding(.horizontal, hPadding) // Match the horizontal padding with MapView
    }
    
    
}

fileprivate func isStreetSweepingDay(sweepingDays: String) -> Bool {
    let calendar = Calendar.current
    let today = Date()
    let components = calendar.dateComponents([.year, .month, .weekday, .weekdayOrdinal], from: today)
    
    guard let year = components.year, let month = components.month, let weekday = components.weekday, let weekdayOrdinal = components.weekdayOrdinal else {
        return false
    }
    
    // Define a dictionary to map weekdays to their corresponding number
    let weekDaysDict = ["Monday": 2, "Tuesday": 3, "Wednesday": 4, "Thursday": 5, "Friday": 6]
    
    // Split the input string into components
    let dayComponents = sweepingDays.components(separatedBy: " ")
    
    // Check if the input string is valid
    if dayComponents.count == 4, let weekDayNumber = weekDaysDict[dayComponents[3]] {
        
        let firstWeek = (dayComponents[0] == "1st") || (dayComponents[2] == "1st")
        let secondWeek = (dayComponents[0] == "2nd") || (dayComponents[2] == "2nd")
        let thirdWeek = (dayComponents[0] == "3rd") || (dayComponents[2] == "3rd")
        let fourthWeek = (dayComponents[0] == "4th") || (dayComponents[2] == "4th")
        
        // Check if today is the specified weekday

        if weekday == weekDayNumber {
            switch weekdayOrdinal {
            case 1:
                return firstWeek
            case 2:
                return secondWeek
            case 3:
                return thirdWeek
            case 4:
                return fourthWeek
            default:
                return false
            }
        }
    }
    
    return false
}


// Preview the StreetSweepingContentView
/*
 #Preview {
 AddressInfoView()
 }
 */
