//
//  NotificationDelegate.swift
//  SwiftUI-Demo
//
//  Created by Tommy Phuoc Ngo on 6/12/24.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content

        if content.categoryIdentifier == "StreetSweepingDailyCheck" {
            let streetSweepingDays = content.body
            let isStreetSweepingDay = isStreetSweepingDay(sweepingDays: content.body)
            let newContent = UNMutableNotificationContent()
            newContent.title = "Street Sweeping Day"
            newContent.body = isStreetSweepingDay 
                ? "Today is a street sweeping day: \(streetSweepingDays)"
                : "Today is not a street sweeping day."
            newContent.sound = UNNotificationSound.default
            
            let newRequest = UNNotificationRequest(identifier: "StreetSweepingDayNotification", 
                                                   content: newContent,
                                                   trigger: nil)
            UNUserNotificationCenter.current().add(newRequest)
            
//            if let addressInfo = content.body {
//                let isStreetSweepingDay = isStreetSweepingDay(sweepingDays: addressInfo)
//
//                let newContent = UNMutableNotificationContent()
//                newContent.title = "Street Sweeping Day"
//                newContent.body = isStreetSweepingDay ? "Today is a street sweeping day: \(addressInfo.streetSweepingDays)" : "Today is not a street sweeping day."
//                newContent.sound = UNNotificationSound.default
//
//                let newRequest = UNNotificationRequest(identifier: "StreetSweepingDayNotification", content: newContent, trigger: nil)
//                //center.add(newRequest)
//                UNUserNotificationCenter.current().add(newRequest)
//            }
        } else {
            // Show the notification as a banner and play a sound
            completionHandler([.banner, .sound])
        }

        completionHandler([])
    }

    private func isStreetSweepingDay(sweepingDays: String) -> Bool {
        // Your existing isStreetSweepingDay implementation
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
}
