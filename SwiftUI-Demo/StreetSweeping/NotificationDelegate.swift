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
        let calendar = Calendar.current
        let today = Date()
        guard let components = calendar.dateComponents([.weekday, .weekdayOrdinal], from: today),
              let weekday = components.weekday,
              let weekdayOrdinal = components.weekdayOrdinal else {
            return false
        }
        
        let weekDaysDict = ["Monday": 2, "Tuesday": 3, "Wednesday": 4, "Thursday": 5, "Friday": 6]
        let ordinalDict = ["1st": 1, "2nd": 2, "3rd": 3, "4th": 4]
        
        let dayComponents = sweepingDays.components(separatedBy: " ")
        guard dayComponents.count == 3,
              let sweepWeekday = weekDaysDict[dayComponents[2]],
              let sweepOrdinal = ordinalDict[dayComponents[0]] else {
            return false
        }
        
        return weekday == sweepWeekday && weekdayOrdinal == sweepOrdinal
    }
}
