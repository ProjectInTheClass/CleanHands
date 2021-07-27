//
//  NotificationController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/07/24.
//

import Foundation
import UserNotifications

struct NotificationController {
    let content = UNMutableNotificationContent()
    let center = UNUserNotificationCenter.current()
    var calendar = Calendar.current
    
    init() {
        content.title = "손이 더러워요!"
        content.body = "손을 안씻은지 오래됐어요! 손을 씻어주세요."
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
    }
    
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
    
    func requestNotification(_ trigger: UNCalendarNotificationTrigger) {
        
        let randomIdentifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: randomIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
          if error != nil {
            print("alarm trigger request went wrong")
          }
        }
    }
    
    func scheduleNotification(_ alarm: Alarm) {
        guard let interval = alarm.repeatTimeToAlarmString?.getTimeInSeconds(),
              let fromHour = alarm.fromToDateComponents.hour,
              let fromMinute = alarm.fromToDateComponents.minute,
              let toHour = alarm.toToDateComponents.hour,
              let toMinute = alarm.toToDateComponents.minute else { return }
        
        let numberOfNotification = 86400 / interval
        
        // from now
        var dateComponents = calendar.dateComponents([.hour, .minute], from: Date())
        
        center.removeAllPendingNotificationRequests()
        
        var lastHour: Int = dateComponents.hour!
        var isNextDay: Bool = false
        
        if alarm.isAlarmOn {
            for _ in Range(1...numberOfNotification) {
                var date = calendar.date(from: dateComponents)!
                date = date + TimeInterval(interval)
                
                dateComponents = calendar.dateComponents([.hour, .minute], from: date)
                
                if lastHour > dateComponents.hour! {
                    isNextDay = true
                }
                
                if alarm.isDoNotDisturbOn {
                    let hour = isNextDay ? dateComponents.hour! + 24 : dateComponents.hour!
                    let minute = dateComponents.minute!
                    
                    let fromTimeInMinutes = fromHour * 60 + fromMinute
                    var toTimeInMinutes = toHour * 60 + toMinute
                    
                    if fromTimeInMinutes > toTimeInMinutes {
                        toTimeInMinutes = toTimeInMinutes + 60 * 24
                    }
                    
                    let currentDateComponentsTimeInMinutes = hour * 60 + minute
                    
                    if fromTimeInMinutes <= currentDateComponentsTimeInMinutes &&
                        currentDateComponentsTimeInMinutes <= toTimeInMinutes {
                        continue
                    }
                }
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                requestNotification(trigger)

                lastHour = dateComponents.hour!
                
                print("alarm!")
                print(dateComponents.hour)
                print(dateComponents.minute)
                print()
            }
        }
    }
}
