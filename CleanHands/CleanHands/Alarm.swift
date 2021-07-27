//
//  Alarm.swift
//  CleanHands
//
//  Created by 신호중 on 2021/07/24.
//

import Foundation

struct Alarm: Codable {
    var isAlarmOn: Bool
    var isDoNotDisturbOn: Bool
    var repeatTime: String
    var repeatTimeToAlarmString: AlarmString? {
        switch repeatTime {
            case "30분":
                return .half
            case "1시간":
                return .oneHour
            case "1시간 30분":
                return .oneHourHalf
            case "2시간":
                return .twoHour
            case "2시간 30분":
                return .twoHourHalf
            case "3시간":
                return .threeHour
            case "3시간 30분":
                return .threeHourHalf
            case "4시간":
                return .fourHour
            default:
                return nil
        }
    }
    
    var from: Date
    var to: Date
    
    var fromToDateComponents: DateComponents {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        let fromTimeComponents = calendar.dateComponents([.hour, .minute], from: from)
        return fromTimeComponents
    }
    
    var toToDateComponents: DateComponents {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        let toTimeComponents = calendar.dateComponents([.hour, .minute], from: to)
        return toTimeComponents
    }
}

enum AlarmString: Int, Codable {
    case half = 0
    case oneHour
    case oneHourHalf
    case twoHour
    case twoHourHalf
    case threeHour
    case threeHourHalf
    case fourHour
    
    static var alarmStringCount: Int = 8
    
    func getTimeInKoreanString() -> String {
        switch self {
        case .half:
            return "30분"
        case .oneHour:
            return "1시간"
        case .oneHourHalf:
            return "1시간 30분"
        case .twoHour:
            return "2시간"
        case .twoHourHalf:
            return "2시간 30분"
        case .threeHour:
            return "3시간"
        case .threeHourHalf:
            return "3시간 30분"
        case .fourHour:
            return "4시간"
        }
    }
    
    func getTimeInSeconds() -> Int {
        switch self {
        case .half:
            return 1800
        case .oneHour:
            return 1800 * 2
        case .oneHourHalf:
            return 1800 * 3
        case .twoHour:
            return 1800 * 4
        case .twoHourHalf:
            return 1800 * 5
        case .threeHour:
            return 1800 * 6
        case .threeHourHalf:
            return 1800 * 7
        case .fourHour:
            return 1800 * 8
        }
    }
}

