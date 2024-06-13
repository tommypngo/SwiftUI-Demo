//
//  ContentViewExample.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/12/24.
//

import SwiftUI
import UserNotifications

struct ContentViewExample: View {
    var body: some View {
        VStack {
            Button("Request Permission") {
                // Request notification permissions
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }

            Button("Schedule Notification") {
                // Schedule the notification
                let content = UNMutableNotificationContent()
                content.title = "Reminder"
                content.body = "Don't forget to check the app!"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            }
        }
    }
}


#Preview {
    ContentViewExample()
}
