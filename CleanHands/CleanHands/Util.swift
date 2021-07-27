//
//  Util.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/06/01.
//

import Foundation
import Charts

let DAY_OF_WEEK_EN
    = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
let DAY_OF_WEEK  = ["월", "화", "수", "목", "금", "토", "일"]


func dateToDayOfWeek(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let dayOfTheWeekString = dateFormatter.string(from: date)
    switch dayOfTheWeekString {
        case DAY_OF_WEEK_EN[0]:
            return DAY_OF_WEEK[0]
            
        case DAY_OF_WEEK_EN[1]:
            return DAY_OF_WEEK[1]
            
        case DAY_OF_WEEK_EN[2]:
            return DAY_OF_WEEK[2]
            
        case DAY_OF_WEEK_EN[3]:
            return DAY_OF_WEEK[3]
            
        case DAY_OF_WEEK_EN[4]:
            return DAY_OF_WEEK[4]
            
        case DAY_OF_WEEK_EN[5]:
            return DAY_OF_WEEK[5]
            
        case DAY_OF_WEEK_EN[6]:
            return DAY_OF_WEEK[6]
            
        default:
            return "error"
    }
}

func getPrevDateBy(daysToSub : Int) ->Date{
    var dateComponents = DateComponents()
    dateComponents.day = -daysToSub
    let PrevDate = Calendar.current.date(byAdding: dateComponents, to: Date())
    return PrevDate!
}

func criteriaFromWeekday(today: Date)-> Int{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let dayOfTheWeekString = dateFormatter.string(from: today)
    
    switch dayOfTheWeekString {
        case DAY_OF_WEEK_EN[0]:
            return 0
            
        case DAY_OF_WEEK_EN[1]:
            return 1
            
        case DAY_OF_WEEK_EN[2]:
            return 2
            
        case DAY_OF_WEEK_EN[3]:
            return 3
            
        case DAY_OF_WEEK_EN[4]:
            return 4
            
        case DAY_OF_WEEK_EN[5]:
            return 5
            
        case DAY_OF_WEEK_EN[6]:
            return 6
        default:
            return -1
    }
}

func daysBetween(start: Date, end: Date) -> Int {
    let calendar = Calendar.current

    // Replace the hour (time) of both dates with 00:00
    let date1 = calendar.startOfDay(for: start)
    let date2 = calendar.startOfDay(for: end)

    let components = calendar.dateComponents([.day], from: date1, to: date2)
    return components.day!
    
}


class DigitValueFormatter : NSObject, IValueFormatter, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let valueWithoutDecimalPart = String(format: "%.0f", value)
        return "\(valueWithoutDecimalPart)"
    }
    

    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let valueWithoutDecimalPart = String(format: "%.0f", value)
        return "\(valueWithoutDecimalPart)"
    }
}



func saveUserState() {
    let documentsDirctory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL = documentsDirctory.appendingPathComponent("userState").appendingPathExtension("json")
            
    let jsonEncodoer = JSONEncoder()
    var jsonData : Data
    do{
        jsonData = try jsonEncodoer.encode(User.userState)
        try jsonData.write(to: archiveURL)
    }catch{
        print(error)
        return
    }
}

func loadUser() -> User{
    
        let documentsDirctory =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirctory.appendingPathComponent("userState").appendingPathExtension("json")
        let jsonDecoder = JSONDecoder()

        var retrievedJsonData : Data
    do{
        var decoded :User
        retrievedJsonData = try Data(contentsOf: archiveURL)
        decoded = try jsonDecoder.decode(User.self, from: retrievedJsonData)
        return decoded
    }catch{
        print(error)
    }
    return User(name: "initName", pathogenDic: [:], washDataList: [], handState: HandState(lastWashTime: Date(), pathogenAmount: 0), exp: 0)
}
