//
//  MainViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/06/09.
//

import UIKit

class MainViewController: UITabBarController {
    @IBOutlet weak var tabBarItems: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snackbarUIView = view
    }
    override func viewDidLayoutSubviews() {
        tabBarItems.items?[0].imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
        tabBarItems.items?[1].imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
        tabBarItems.items?[2].imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
    }
}

var snackbarUIView:UIView?
//데이터 전달을 이렇게 하는게 최선인가..?
