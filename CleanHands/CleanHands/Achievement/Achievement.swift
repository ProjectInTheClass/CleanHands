//
//  Achievement.swift
//  CleanHands
//
//  Created by hwangguk on 2021/07/18.
//

import Foundation

struct AchievementManager:Codable{
    var completedAchievements: [Achievement]
    var appearedAchievements: [Achievement]
    var entireAchievements: [Achievement]
    
    static func updateAchievement () -> [String]{
        var updated:[String] = []
        var changed = false
        for achievement in User.userState.achievementManager.entireAchievements {
            if (achievement.appeared) {
                User.userState.achievementManager.appearedAchievements.append(achievement)
                if let index = User.userState.achievementManager.entireAchievements.firstIndex(of: achievement) {
                    User.userState.achievementManager.entireAchievements.remove(at: index)
                }
                changed = true
                updated.append("신규 업적 " + achievement.name + " 추가")
            }
        }
        if (changed) {
            updated += compeleteAchievement()
        }
        return updated
    }
    static func compeleteAchievement() -> [String]{
        var compeleted:[String] = []
        var changed = false
        for var achievement in User.userState.achievementManager.appearedAchievements {
            if (achievement.completed) {
                achievement.completeDate = Date()
                User.userState.achievementManager.completedAchievements.append(achievement)
                if let index = User.userState.achievementManager.appearedAchievements.firstIndex(of: achievement) {
                    User.userState.achievementManager.appearedAchievements.remove(at: index)
                }
                changed = true
                compeleted.append(achievement.name + " 완료")
            }
        }
        if (changed) {
            User.addAvailablePathogens()
            compeleted += updateAchievement()
        }
        return compeleted
    }
}

struct Achievement:Equatable, Codable{
    let id: Int
    let name: String
    let description: String
    let reward: Int
    let appearConditions: [Achievement]
    let completeConditions: [Pathogen:Int]
    var completeDate:Date?
    
    var appeared:Bool {
        for achievementCondition in appearConditions {
            if (!User.userState.achievementManager.completedAchievements.contains(achievementCondition)) {
                return false
            }
        }
        return true
    }
    
    var completed: Bool {
        let userPathogenDic = User.userState.pathogenDic
        for (pathogen, number) in self.completeConditions {
            guard let pathogenAmount = userPathogenDic[pathogen] else {
                return false
            }
            if (pathogenAmount < number) {
                return false
            }
        }
        
        return true
    }
    
    init(name:String, description:String, completeConditions:[Pathogen:Int], appearConditions: [Achievement], id:Int) {
        self.name = name
        self.description = description
        self.completeConditions = completeConditions
        self.appearConditions = appearConditions
        self.reward = 0
        self.id = id
    }
    static func == (lhs:Achievement, rhs:Achievement)->Bool {
        return lhs.id == rhs.id
    }
}
