//
//  TabBarViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/11/20.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        UITabBar.appearance().backgroundImage = UIImage.init(named: "marble@2x.jpg")
        // タップしたときの色を変更
        tabBar.tintColor = UIColor.black
        
        
    }
   
}
