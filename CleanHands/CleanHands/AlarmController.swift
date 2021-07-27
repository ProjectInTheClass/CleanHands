//
//  AlarmController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/07/24.
//

import Foundation

struct AlarmController {
    var alarm: Alarm?
    
    mutating func loadAlarmFromUserState() {
        if let alarm = User.userState.alarm {
            self.alarm = alarm
        } else {
            self.alarm = Alarm(isAlarmOn: false, isDoNotDisturbOn: false, repeatTime: AlarmString.twoHour.getTimeInKoreanString(), from: Date(), to: Date())
        }
    }
    
    func saveAlarmToUserState() {
        User.userState.alarm = alarm
        saveUserState()
    }
}


