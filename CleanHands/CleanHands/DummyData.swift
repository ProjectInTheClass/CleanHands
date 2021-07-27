//
//  DummyData.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/05/06.
//

import Foundation
import UIKit

//병원체
struct Pathogen : Equatable, Codable{
    static func == (lhs: Pathogen, rhs: Pathogen) -> Bool {
        return lhs.name == rhs.name
    }
    
    let type: PathogenType
    let name: String
    let exp: Int
    let description: String
    let illnesses : [String]
    let symptom : String
    let careMethod : String
    let location : String
    let frequency : Frequency
    let image : String
    
    let requiredAchievements:[Achievement]
    var requireSatisfied: Bool {
        for achievement in requiredAchievements {
            if !User.userState.achievementManager.completedAchievements.contains(achievement) {
                return false
            }
        }
        return true
    }
}

extension Pathogen : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}

enum Frequency :String, Codable{
    case high, medium, low
    
    var toString: String {
        switch self {
        case .high:
            return "상"
        case .medium:
            return "중"
        case .low:
            return "하"
        }
    }
}

enum PathogenType : Int, Codable{
    case bacteria // 세균
    case virus    // 바이러스
    case mold     // 곰팡이
}

struct User : Codable{
//    static var userState = User(name: "initName", pathogenDic: [:], washDataList: [], handState: HandState(lastWashTime: Date(), pathogenAmount: 0), exp: 0)
    
    static var userState = loadUser()
    
    var currentPathogenCountList = Array<Int>()
    
    var availablePathogens = [Pathogen]()
    var achievementManager = AchievementManager(completedAchievements: [Achievement](), appearedAchievements: [Achievement](), entireAchievements: achievementList)
    var name: String
//    var profileImage : String?
    var pathogenDic: [Pathogen: Int]
    var washDataList: [WashData]
    var handState: HandState
    var exp: Int
    var alarm: Alarm?
    
    static func addAvailablePathogens() {
        for pathogen in pathogenList {
            if (!userState.availablePathogens.contains(pathogen) && pathogen.requireSatisfied) {
                userState.availablePathogens.append(pathogen)
            }
        }
    }
    
}

struct WashData : Codable{
    let date: Date
    var capturedPathogenDic : [Pathogen : Int]
}

struct HandState: Codable{
    var lastWashTime: Date
    var pathogenAmount: Int
}


var escherichiaCoil = Pathogen(type: .mold, name: "대장균", exp: 10, description: "제 2 위험군\n전략물자통제병원체\nEnterobacteriaceae과, 그람음성, 간균, 주모(peritrichous flagella)를 가지고 있어 운동성 있음, 포자형성 안함.", illnesses: [], symptom: "패혈증, 요로감염, 위장관염, 수막염, 폐렴 등 다양한 질병", careMethod: "수분공급, 전해질 교정, EPEC, EIEC의 경우 tremethoprim-sulfamethoxazole, quineolones, EHEC는 용혈성요독증후군 유발 위험으로 항생제 사용이 권장되지 않음.", location: "오염된 음식, 물 섭취, 분변-경구 매개체를 통한 감염, 사람-사람 간 전파에 의하여 감염.", frequency: Frequency.high, image: "EscherichiaCoil.png", requiredAchievements: [achievement_tutorial])
var salmonella = Pathogen(type: .mold, name: "살모넬라균", exp: 10, description: "제 2 위험군\n전략물자통제병원체\nEnterobacteriaceae과, 그람음성, 막대균, 주모성 편모가 있어 운동성 활발, 조건무산소성", illnesses: [], symptom: "발열, 두통, 오심, 구토, 복통, 설사 등의 위장증상", careMethod: "경구 또는 정맥으로 수분보충, 항상제 치료", location: "오염된 물(지하수 및 음용수 등)이나 음식을 통한 전파\n살모넬라균에 감염된 동물이나 감염된 동물 주변 환경에 접촉하여 감염", frequency: Frequency.high, image: "Salmonellas.png", requiredAchievements: [])
//var coronaVirus = Pathogen(type: .virus, name: "코로나 바이러스", exp: 5, description: "제 2 위험군\nCoronaviridae과 Coronavirinae속, (+)ssRNA, 나선형 뉴클레오캡시드, 외피 있음", illnesses: [], symptom: "급성 호흡기감염증을 유발", careMethod: "보존적 치료", location: "호흡기 비말 흡입, 분변­경구 경로 전파", frequency: Frequency.high, image: "Coronavirus.png",requiredAchievements: [achievement_esch])
var sars = Pathogen(type: .virus, name: "사스 바이러스", exp: 20, description: "제 3 위험군\n고위험병원체, 생물작용제, 전략물자통제병원체\nCoronaviridae과, Betacoronavirus속, (+)ssRNA 바이러스, 피막 있음, 왕관모양", illnesses: [], symptom: "중증 급성 호흡기 증후군(SARS)을 유발\n 초기에는 감기와 비슷한 증상, 2~7일 후에 마른 헛기침, 호흡 곤란 또는 저산소증과 같은 호흡기 증상", careMethod: "항바이러스제는 없으며, 환자 상태에 따라 대증치료, 유효한 백신 없음", location: "주로 호흡기 비말을 통해 감염됨. 감염자와의 밀접한 접촉이나 감염자의 인체 분비액이 눈, 코, 입 등의 점막에 직접 또는 간접적으로 접촉되는 경우 감염", frequency: Frequency.low, image: "SARS.png", requiredAchievements: [achievement_esch])
var ebolaVirus = Pathogen(type: .virus, name: "에볼라 바이러스", exp: 30, description: "제 4 위험군\n고위험병원체, 생물작용제, 전략물자통제병원체\n6종이 있음 (-)ssRNA 바이러스, 긴막대기형, 고리형, 원형 등 다양한 형태", illnesses: [], symptom: "에볼라바이러스병 또는 에볼라출혈열을 유발\n오심, 구토, 설사, 발진, 신장 및 간기능 손상이 동반되고 때로 체내･외 출혈", careMethod: "허가받은 치료제는 없으나 수분 및 전해질 보충, 혈압 조절 및 체내 적정 산소 유지, 감염 합병증에 대한 치료 등 대증요법\n 미국 및 유럽연합에서 승인받은 백신 있음", location: "감염된 동물, 사람에 직접적 또는 간접적 접촉\n 환자의 혈액 또는 체액(타액, 소변, 구토물, 대변 등) 및 환자의 혈액이나 체액으로 오염된 옷, 침구류, 감염된 바늘 등을 통해 피부상처 또는 점막을 통해 직접 접촉으로 감염되거나 성 접촉(정액)\n 모유수유 등을 통해서도 감염.", frequency: Frequency.low, image: "Ebolavirus.png",requiredAchievements: [achievement_lassa])
var zikaVirus = Pathogen(type: .virus, name: "지카 바이러스", exp: 10, description: "제 2 위험군\nFlaviviridae과, Flavivirus속, (+)ssRNA,정이십면체, 외피 있음", illnesses: [], symptom: "반점구진성 발진을 동반한 갑작스러운 발열, 결막염, 근육통, 두통이 동반될 수 있음", careMethod: "충분한 휴식 및 수분 섭취하면 대부분 회복. 증상이 있을 경우 진통제, 해열제 치료 가능", location: "숲모기에 의한 전파로 감염되며 감염자와 일상적인 접촉으로 감염되지 않음.\n이집트 숲모기가 주된 매개체이나 국내 서식하는 흰줄 숲모기도 전파 가능\n 성접촉에 의해 감염될 수 있음.", frequency: Frequency.medium, image: "Zikavirus.png",requiredAchievements: [achievement_esch])
var noroVirus = Pathogen(type: .virus, name: "노로 바이러스", exp: 8, description: "제 2위험군\nCaliciviridae과, Norovirus속, (+)ssRNA,외피 없음", illnesses: [], symptom: "급성위장관염을 유발\n오심, 구토, 설사, 복통, 권태감, 열 등이 나타나며 위장관 증상은 24~48시간 지속될 수 있음", careMethod: "보존적 치료", location: "분변-경구 경로가 주된 전파경로이며, 구토물에 의한 비말 감염 가능함.\n 우리나라에서는 급식시설 오염된 음식, 물 섭취에 의해 감염됨.", frequency: Frequency.low, image: "Norovirus.png",requiredAchievements: [achievement_danger3])
var blastomycesDermatitidis = Pathogen(type: .mold, name: "블라스토마이세스", exp: 15, description: "제 3위험군\nAjellomycetaceae과, 두형태 진균(Dimorphic fungi), 북아메리카, 미국 오하이오 미시시피강 계곡에 주로 분포함 ", illnesses: [], symptom: "전신성 진균증\n대부분 무증상이며, 일부에서 폐렴이 발생하거나 자연 치유", careMethod: "적절한 항진균 요법(amphotericin B, itraconazole)", location: "에어로졸화된 분생자의 폐흡입에 의하여 감염\n사람 간 전파는 일어나지 않음.", frequency: .medium, image: "BlastomycesDermatitidis.png",requiredAchievements: [achievement_sars])
var lassaVirus = Pathogen(type: .virus, name: "라싸 바이러스", exp: 25, description: "제 4위험군\n고위험병원체, 생물작용제, 전략물자통제병원체\nArenaviridae과, Mammarenavirus속, 부정형이나 대체로 구형, (-)ssRNA 바이러스, 피막 있음", illnesses: [], symptom: "급성 바이러스성 질환인 라싸열을 유발\n발열의 징후와 증상은 바이러스 접촉 후 1~3주 사이에 나타남\n생존 시 8~10일 내 호전\n감염자의 80%는 증상이 경미하거나 무증상\n그러나 감염자 20%에서는 간, 비장 및 신장 등 여러 기관에 영향을 미치는 심각한 질병을 초래", careMethod: "상용화된 특이 치료제는 없으나 항바이러스제 리바비린(ribavirin)을 초기 투여한 경우 치료 효과를 보임\n 수액 공급, 전해질 균형 유지 등 대증요법으로 치료", location: "감염된 설치류에게 물리거나 감염된 설치류의 타액, 분비물, 혈액 등의 직접적 접촉 또는 에어로졸 흡입으로 감염됨\n 에어로졸로 사람 간 전파가 가능함.\n 감염된 사람의 소변, 인두분비물 등을 통하여 전파 가능하며, 성 접촉으로도 전파될 수 있음.\n 오염된 주사바늘 및 의료기기에 의한 병원 내 감염도 발생함", frequency: .low, image: "Lassavirus.png",requiredAchievements: [achievement_polio3])
var polioVirus = Pathogen(type: .virus, name: "폴리오 바이러스", exp: 10, description: "제 2위험군\n3가지 혈청형(type 1, 2, 3)으로 구분되고 야생형 폴리오바이러스 type 2는 2015년, type 3는 2019년 WHO에 의해 박멸 선언됨. 야생형 폴리오바이러스 type 1은 최근 2년간 아프가니스탄 및 파키스탄 일부 지역에서만 발견됨", illnesses: [], symptom: "급성 이완성 마비를 일으키는 폴리오(poliomyelitis)를 유발", careMethod: "항바이러스제는 없으며 증상의 완화, 회복 속도 및 급성기 마비와 같은 합병증 발생에 주의하며 대증치료. 증상이 호전된 후에는 치유되지 않는 마비에 대한 재활치료", location: "분변­경구 또는 경구-경구 경로로 전파됨.\n 드물게 분변에 오염된 음식물을 통해서도 전파 가능함.\n 위생 환경이 잘 정비된 나라에서는 인두, 후두 감염물로 전파", frequency: .low, image: "Poliovirus.png",requiredAchievements: [achievement_zika, achievement_sars])

var pathogenList = [escherichiaCoil, salmonella, sars, ebolaVirus, zikaVirus, noroVirus, blastomycesDermatitidis, lassaVirus, polioVirus]

//func generateWashDummies() -> [WashData]{
//    var list :[WashData] = []
//
//    for _ in 0...99{
//        let temp = arc4random_uniform(21);
//        list.append(WashData(date: getPrevDateBy(daysToSub: Int(temp)), capturedPathogenDic: dummyPathogenDic))
//
//    }
//    return list
//}
//
//var randomWashList = generateWashDummies()
//
//func generateTestWashDataList() -> [WashData]{
//    var list :[WashData] = []
//
//    for i in 0...21{
//        list.append(WashData(date: getPrevDateBy(daysToSub: i), capturedPathogenDic: dummyPathogenDic))
//    }
//    return list
//}
//
//
//
//var testWashList = generateTestWashDataList()

var achievement_tutorial = Achievement(name: "튜토리얼", description: "살모넬라균 3000마리 퇴치", completeConditions: [salmonella:3000], appearConditions: [], id: 0)
var achievement_esch = Achievement(name: "대장균 퇴치 1", description: "대장균 50000마리 퇴치", completeConditions: [escherichiaCoil:50000], appearConditions: [achievement_tutorial], id: 1)
var achievement_sal = Achievement(name: "살모넬라균 퇴치", description: "살모넬라균 10000마리 퇴치", completeConditions: [salmonella:10000], appearConditions: [achievement_tutorial], id: 2)
var achievement_esch2 = Achievement(name: "대장균 퇴치 2", description: "대장균 100000마리 퇴치", completeConditions: [escherichiaCoil:100000], appearConditions: [achievement_esch], id: 3)
var achievement_esch3 = Achievement(name: "대장균 퇴치 3", description: "대장균 200000마리 퇴치", completeConditions: [escherichiaCoil:200000], appearConditions: [achievement_esch2], id: 4)
//var achievement_corona = Achievement(name: "코로나바이러스 퇴치", description: "코로나바이러스 50000마리 퇴치", completeConditions: [coronaVirus:50000], appearConditions: [achievement_esch], id: 5)
var achievement_zika = Achievement(name: "모기 매개 병원체 퇴치", description: "지카 바이러스 50000마리 퇴치", completeConditions: [zikaVirus:50000], appearConditions: [achievement_esch], id: 6)
var achievement_sars = Achievement(name: "사스 바이러스 퇴치", description: "사스 바이러스 30000마리 퇴치", completeConditions: [sars:30000], appearConditions: [achievement_esch], id: 7)
var achievement_danger3 = Achievement(name: "제 3 위험군 퇴치", description: "사스 바이러스 120000마리, 블라스토 마이세스 100000마리 퇴치", completeConditions: [sars:120000, blastomycesDermatitidis:100000], appearConditions: [achievement_sars], id: 8)
var achievement_polio = Achievement(name: "폴리오 바이러스 퇴치1", description: "폴리오 바이러스 50000마리 퇴치", completeConditions: [polioVirus:50000], appearConditions: [achievement_sars, achievement_zika], id: 9)
var achievement_noro = Achievement(name: "급성 위장염 유발하는 바이러스", description: "노로 바이러스 100000마리 퇴치", completeConditions: [noroVirus:100000], appearConditions: [achievement_danger3], id: 10)
var achievement_polio2 = Achievement(name: "폴리오 바이러스 퇴치2", description: "폴리오 바이러스 150000마리 퇴치", completeConditions: [polioVirus:150000], appearConditions: [achievement_polio], id: 11)
var achievement_polio3 = Achievement(name: "폴리오 바이러스 퇴치3", description: "폴리오 바이러스 300000마리 퇴치", completeConditions: [polioVirus:300000], appearConditions: [achievement_polio2], id: 12)
var achievement_lassa = Achievement(name: "라싸 바이러스 퇴치", description: "라싸 바이러스 100000마리 퇴치", completeConditions: [lassaVirus:100000], appearConditions: [achievement_polio3], id: 13)
var achievement_danger4 = Achievement(name: "제 4 위험군 퇴치", description: "라싸 바이러스 200000마리, 에볼라바이러스 100000마리 퇴치", completeConditions: [lassaVirus:200000, ebolaVirus: 100000], appearConditions: [achievement_lassa], id: 14)


var achievementList:[Achievement] = [achievement_lassa, achievement_polio3, achievement_polio, achievement_danger3, achievement_zika, achievement_sars, achievement_esch2, achievement_sal, achievement_noro, achievement_esch, achievement_esch3, achievement_polio2, achievement_danger4, achievement_tutorial]

