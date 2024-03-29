//
//  WashResultViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/05/23.
//

import UIKit

class TimerModalViewController: UIViewController {
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var modalButton: UIButton!
    @IBOutlet weak var washProgressBar: UIProgressView!
    var scaled = false
    var handViewController:HandViewController?

    private var customTransitioningDelegate = TransitioningDelegate()
    
    var timer: Timer?
    var completeWash = false
    
    var remainTime = 20
    let totalTime:Float = 20
    var timeText:String {
        if (remainTime > 9) {
            return "00 : " + String(remainTime)
        }
        return "00 : 0" + String(remainTime)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        animateModal()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        animateModal()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if (!scaled) {
            washProgressBar.transform = washProgressBar.transform.scaledBy(x: 1, y: 1.5)
            scaled = true
        }
        washProgressBar.layer.cornerRadius = 3
        washProgressBar.clipsToBounds = true
        washProgressBar.layer.sublayers![1].cornerRadius = 3
        washProgressBar.subviews[1].clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerStart()
        // Do any additional setup after loading the view.
    }
    
    func timerStart() {
        washProgressBar.progress = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimePassed), userInfo: nil, repeats: true)
    }
    
    @objc func onTimePassed() {
        washProgressBar.progress += 1/totalTime
        remainTime -= 1
        remainTimeLabel.text = timeText
        
        if (remainTime <= 0) {
            timer?.invalidate()
            timer = nil
            completeWash = true
            modalButton.setTitle("완료", for: .normal)
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    func animateModal() {
        //view.layer.cornerRadius = 25
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical             // use whatever transition you want
        transitioningDelegate = customTransitioningDelegate
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if (completeWash) {
            //handViewController?.captureSuccess = true
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class PresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: bounds.width, height: bounds.height/4)
        let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.height - size.height)
        return CGRect(origin: origin, size: size)
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        presentedView?.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleBottomMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin
        ]

        presentedView?.translatesAutoresizingMaskIntoConstraints = true
    }
}
