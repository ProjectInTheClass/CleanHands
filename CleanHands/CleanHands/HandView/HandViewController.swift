//
//  HandViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/05/07.
//


//TODO 타이머 관리
import UIKit
import GameplayKit
import HealthKit

class HandViewController: UIViewController {
    let widthGererater = GKGaussianDistribution(randomSource: GKRandomSource(), lowestValue: -2, highestValue: 8)
    let handMatrix = [[2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5],
                      [2.7 ,2.7, 2.9, 2.9, 3.1, 3.1, 3.3],
                      [0.5, 1, 2, 3, 4, 5, 5.5],
                      [1, 1, 2, 3, 4, 5, 5.5],
                      [0.5, 1, 2, 3, 4, 5, 5.5],
                      [0.7, 1, 2, 2.5, 1, 2, 2.5],
                      [1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5]]
    
    
    var capturedPathogenDic = [Pathogen:Int]()
    
    var washDataViewString = "무슨 세균을 잡았을까?"
    
    let pathogenCreateInterval:Double = 1
    let maxPathogenNum = 120
    let percentageOfGettingRarePathogen = 0.3
    let percentageOfGettingEpicPathogen = 0.1
    let percentageOfGettingCommonPathogen = 0.5
    let dirtyPathogenNumber:Int = 1
    
    var pathogenImageList = Array<UIImageView>()
    
    var currentPathogenCount:Int {
        var num = 0
        for n in User.userState.currentPathogenCountList {
            num += n
        }
        return num
    }
    
    func addPathogenImageList(imageView:UIImageView) {
        pathogenImageList.append(imageView)
        User.userState.currentPathogenCountList.append(Int.random(in: Range(100...1000)))
    }
    func flushPathogenImageList(){
        pathogenImageList = Array<UIImageView>()
        User.userState.currentPathogenCountList = Array<Int>()
    }
    
    var isHealthKitLoaded = false
    
    var timerModalView : TimerModalViewController?
//    var captureSuccess = false {
//        didSet {
//            if (captureSuccess) {
//                if let timerModalView = timerModalView {
//                    timerModalView.dismiss(animated: false, completion: nil)
//                    removePathogen()
//                    saveUserState()
//                }
//                presentWashResultView()
//                captureSuccess = false
//            }
//        }
//    }
    

    @IBOutlet weak var handImageView: UIImageView!
    
    @IBOutlet weak var explainText: UILabel!
    @IBOutlet weak var washButton: UIButton!
    
    let pathogenImage = UIImage(named: "HandPathogen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handImageView.layoutIfNeeded()
        updateUI()
        startTimer()
        AchievementManager.updateAchievement()
        User.addAvailablePathogens()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onTimePassed()
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: pathogenCreateInterval, target: self, selector: #selector(onTimePassed), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkReload), userInfo: nil, repeats: true)
    }
    
    
    func createPathogen(numberOfCreate number:Int, applyCountList:Bool) {
        view.layoutIfNeeded()
        let imageLeftX = handImageView.frame.minX
        let imageUpY = handImageView.frame.minY
        let devidedImageWidth = Int(handImageView.frame.size.width/7)
        
        for _ in Range(1...number) {
            if (pathogenImageList.count >= maxPathogenNum) {
                break
            }
            let pathogenView = UIImageView(image: pathogenImage)
            
            var randomWidthIndex = widthGererater.nextInt()
            if (randomWidthIndex < 0) {
                randomWidthIndex = 0
            }
            if (randomWidthIndex > 6) {
                randomWidthIndex = 6
            }
            let widthRange = Range(devidedImageWidth * randomWidthIndex...devidedImageWidth * (randomWidthIndex + 1))
            let randomWidth = Int.random(in: widthRange)
            let heightRange = getRandomPositionRange(widthIndex: randomWidthIndex)
            
            let x = UInt32(randomWidth) + UInt32(imageLeftX)
            let y = Int.random(in: heightRange) + Int(imageUpY)
            
            pathogenView.frame = CGRect(x: Int(x), y: y, width: 10, height: 10)
            
            self.view.addSubview(pathogenView)
            if (applyCountList) {
                addPathogenImageList(imageView: pathogenView)
            }
            else {
                pathogenImageList.append(pathogenView)
            }
            
            User.userState.handState.pathogenAmount = currentPathogenCount
        }
    }
    
    //손 모양에 맞춰 세균을 생성하기 위한 함수
    func getRandomPositionRange(widthIndex:Int) -> Range<Int>{
        let devidedImageHeight = handImageView.frame.size.height/7
        let yIndexinMatrix = Int.random(in: 0...6)
        let matrixValue = CGFloat(handMatrix[widthIndex][yIndexinMatrix])
        let startRange = Int(devidedImageHeight*matrixValue)
        let endRange = Int(devidedImageHeight*(matrixValue+1.0))

        return Range(startRange...endRange)
    }
    
    @objc func checkReload() {
        if (appBecomeActive) {
            getWashData()
            appBecomeActive = false
        }
    }
    @objc func onTimePassed() {
        let currentDate = Date()
        var expectedPathongenNumber = Int(currentDate.timeIntervalSince(User.userState.handState.lastWashTime)/pathogenCreateInterval)
        expectedPathongenNumber = 120

        if (expectedPathongenNumber < pathogenImageList.count) {
            for i in pathogenImageList {
                i.removeFromSuperview()
            }
            flushPathogenImageList()
        }
        if (pathogenImageList.count != User.userState.currentPathogenCountList.count) {
            if (pathogenImageList.count == 0) {
                createPathogen(numberOfCreate: User.userState.currentPathogenCountList.count, applyCountList: false)
            }
            else {
                print("unexpected bug");
            }
        }
        if (pathogenImageList.count < expectedPathongenNumber)  {
            createPathogen(numberOfCreate: expectedPathongenNumber - pathogenImageList.count, applyCountList: true)
            //createPathogen(numberOfCreate: 500)
        }
        updateUI()
        saveUserState()
    }
    
    func updateUI() {
        let timeInterval = Date().timeIntervalSince(User.userState.handState.lastWashTime)
        let hour = Int(timeInterval/3600)
        let min = (Int(timeInterval) % 3600)/60
        if (hour > 23) {
            washButton.isEnabled = true
            explainText.text = "마지막으로 손을 씻은 지 오랜 시간이 지났습니다.\n\(currentPathogenCount) 마리의 세균을 서둘러 씻어내세요!"
            let attributedStr = NSMutableAttributedString(string: explainText.text!)
            attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 178/255, green: 211/255, blue: 227/255, alpha: 1), range: (explainText.text! as NSString).range(of: "\(currentPathogenCount) 마리"))
            explainText.attributedText = attributedStr
        }
        else if (pathogenImageList.count >= dirtyPathogenNumber){
            washButton.isEnabled = true
            explainText.text = "마지막으로 손을 씻은 지 \(hour)시간 \(min)분 지났습니다. \n\(currentPathogenCount) 마리의 세균을 서둘러 씻어내세요!"
            let attributedStr = NSMutableAttributedString(string: explainText.text!)
            attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 178/255, green: 211/255, blue: 227/255, alpha: 1), range: (explainText.text! as NSString).range(of: "\(hour)시간 \(min)분"))
            attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 178/255, green: 211/255, blue: 227/255, alpha: 1), range: (explainText.text! as NSString).range(of: "\(currentPathogenCount) 마리"))
            explainText.attributedText = attributedStr
        }
        else {
            washButton.isEnabled = false
            explainText.text = "손이 깨끗해요!"
        }
    }
    
    func removePathogen() {
        User.userState.handState.lastWashTime = Date()
        capturedPathogenDic = [Pathogen:Int]()
        var iter = 0
        for i in pathogenImageList {
            getRandomPathogen(User.userState.currentPathogenCountList[iter])
            iter += 1
            i.removeFromSuperview()
        }
        let newWashData = WashData(date: Date(), capturedPathogenDic: capturedPathogenDic)
        User.userState.washDataList.append(newWashData)
        
        for (capturedPathogen, number) in capturedPathogenDic {
            if (User.userState.pathogenDic[capturedPathogen] != nil) {
                User.userState.pathogenDic[capturedPathogen]! += number
            }
            else {
                User.userState.pathogenDic[capturedPathogen] = number
            }
        }
        achievementCompeleteCheck()
        
        flushPathogenImageList()
    }
    func achievementCompeleteCheck() {
        let snackbarTexts = AchievementManager.compeleteAchievement()
        for text in snackbarTexts {
            SnackbarView(text: text, view).animate()
        }
    }

    func getRandomPathogen(_ num:Int) {
        let randomInt = Int.random(in: 0...User.userState.availablePathogens.count-1)
        let newPathogen = User.userState.availablePathogens[randomInt]
        
        var percentageOfGettingPathogen:Double
        
        switch newPathogen.frequency {
            case .high:
                percentageOfGettingPathogen = percentageOfGettingCommonPathogen
                break
            case .medium:
                percentageOfGettingPathogen = percentageOfGettingRarePathogen
                break
            case .low:
                percentageOfGettingPathogen = percentageOfGettingEpicPathogen
        }
        if (drand48() < percentageOfGettingPathogen) {
            if (capturedPathogenDic[newPathogen] != nil) {
                capturedPathogenDic[newPathogen]! += num
            }
            else {
                capturedPathogenDic[newPathogen] = num
            }
        }
    }

    @IBAction func onWashButtonPressed(_ sender: Any) {
        washDataViewString = "무슨 세균을 잡았을까?"
        removePathogen()
        saveUserState()
        presentWashResultView()
    }
    
//    func presentTimerModal() {
//        guard let getTimerModalView = self.storyboard?.instantiateViewController(identifier: "timerModalView") else {return}
//        let timerModalView = getTimerModalView as! TimerModalViewController
//        timerModalView.handViewController = self
//        self.timerModalView = timerModalView
//        self.present(timerModalView, animated: true)
//    }
    
    func presentWashResultView() {
        guard let resultView = self.storyboard?.instantiateViewController(identifier: "resultView") else {return}
        resultView.modalTransitionStyle = .coverVertical
        let washResultView = resultView as! WashResultViewController
        washResultView.handViewController = self
        washResultView.titleString = washDataViewString
        self.present(washResultView, animated: true)
    }
    
    func getWashData() {
        HealthKitManager.shared.readRecentHandWash(for: Date()) {sample,_ in
            if let washSample = sample as? HKCategorySample {
                let washDate = washSample.endDate
                if (User.userState.handState.lastWashTime < washDate) {
                    self.capturedPathogenDic = [Pathogen:Int]()
                    
                    let timeInterval  = washDate.timeIntervalSince(User.userState.handState.lastWashTime)
                    User.userState.handState.lastWashTime = washDate
                    
                    var pathogenCount = Int(timeInterval/self.pathogenCreateInterval)
                    if (pathogenCount > self.maxPathogenNum) {
                        pathogenCount = self.maxPathogenNum
                    }
                    
                    for _ in Range(0...pathogenCount) {
                        self.getRandomPathogen(Int.random(in: Range(100...1000)))
                    }
                    
                    let newWashData = WashData(date: washDate, capturedPathogenDic: self.capturedPathogenDic)
                    User.userState.washDataList.append(newWashData)
                    
                    for (capturedPathogen, number) in self.capturedPathogenDic {
                        if (User.userState.pathogenDic[capturedPathogen] != nil) {
                            User.userState.pathogenDic[capturedPathogen]! += number
                        }
                        else {
                            User.userState.pathogenDic[capturedPathogen] = number
                        }
                    }
                    
                    self.onTimePassed()
                    
                    //AchievementManager.updateAchievement()
                    self.achievementCompeleteCheck()
                    
                    self.washDataViewString = "접속하지 않는 동안 손을 씻었어요!"
                    //self.captureSuccess = true
                    self.presentWashResultView()
                    saveUserState()
                }
            }
            
        }
    }
}

struct HealthKitManager {
    let healthStore:HKHealthStore
    
    public static let shared = HealthKitManager()
    
    public init() {
        healthStore = HKHealthStore()
    }
    
    func readRecentHandWash(for date:Date, completion: @escaping (HKSample?, Error?) -> Void)  {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        guard let handWash = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier.handwashingEvent) else {
            fatalError("unable to get hand wash data")
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [handWash]) { (success, error) in
            let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
            let query = HKSampleQuery(sampleType: handWash,
                                      predicate: predicate,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (query, samples, error) in
                
                DispatchQueue.main.async {
                    
                    if let err = error {
                        completion(nil, err)
                    } else {
                        guard let actualSamples = samples else {
                            completion(nil, error) // Here you will not get any error, but you have no data, so you have to pass custom error object that shows no data found.
                            return
                        }
                        
                        completion(actualSamples.first, nil)
                    }
                }
            }
            healthStore.execute(query)
            
        }
    }
}
