//
//  NotificationController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/07/24.
//

import Foundation
import UserNotifications

struct NotificationController {
    func setNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter
        .requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if !granted {
                print("User has declined notifications")
            }
        }
        
        notificationCenter.getNotificationSettings {
            (settings) in
              if settings.authorizationStatus != .authorized {
                // Notifications not allowed
              }
        }
    }
    
    func scheduleNotification(_ alarm: Alarm) {
        guard let interval = alarm.repeatTimeToAlarmString?.getTimeInSeconds() else { return }
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        if alarm.isAlarmOn {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            
            content.title = "손이 더러워요!"
            content.body = "손을 안씻은지 오래됐어요! 손을 씻어주세요."
            content.categoryIdentifier = "alarm"
            content.sound = UNNotificationSound.default
            
            if alarm.isDoNotDisturbOn {
                var calendar = Calendar.current
                calendar.locale = Locale.current
                calendar.timeZone = TimeZone.current
                
                let currentTimeComponents = calendar.dateComponents([.hour, .minute], from: Date())
                
                // 비교를 위한 Date 치환
                let fromComponentDate = calendar.date(from: alarm.fromToDateComponents)
                let toComponentDate = calendar.date(from: alarm.toToDateComponents)
                let currentComponentDate = calendar.date(from: currentTimeComponents)
                
                calendar.date(byAdding: .second, value: interval, to: Date())
                
                print(alarm.fromToDateComponents)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: alarm.fromToDateComponents, repeats: true)
                
                print(alarm.fromToDateComponents)
                
                let content = UNMutableNotificationContent()
                content.title = "Daily reminder"
                content.body = "Enjoy your day!"

                let randomIdentifier = UUID().uuidString
                let request = UNNotificationRequest(identifier: randomIdentifier, content: content, trigger: trigger)

                print("alarm set")
                
                UNUserNotificationCenter.current().add(request) { error in
                  if error != nil {
                    print("something went wrong")
                  }
                }
                
            } else {
                
            }
            
        }
        
        
//        
//        let now = Date()
//        
//        var i = interval
//        
//        while true {
//            let date: Date = now + TimeInterval(i)
            
//            if isDoNotDisturbOn {
//
//                let fromTime = User.userState.doNotDisturbFrom!
//                let toTime = User.userState.doNotDisturbTo!
//
//                print(fromTime)
//                print(date)
//                print("now \(now)")
//                print(toTime)
//                print()
//                if fromTime <= date && date <= toTime {
//
//
//                    i = i + interval
//                    if i > 86400 {
//                        break
//                    }
//                    continue
//                }
//            }
            
//            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
//
//            print(dateComponents)
//
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//            center.add(request)
//
//            i = i + interval
//            if i > 86400 {
//                break
//            }
//        }
    }
    
    func getCurrentLocaleFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.locale = Locale.current
        return dateFormatter
    }
}
