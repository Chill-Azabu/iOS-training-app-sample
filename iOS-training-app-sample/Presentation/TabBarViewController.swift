//
//  TabBarViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeView = HomeViewController.createInstance()
        homeView.tabBarItem = UITabBarItem(title: "home", image: nil, tag: 1)
        let homeBar = UINavigationController(rootViewController: homeView)

        let logoutView = LogoutViewController.createInstance()
        logoutView.tabBarItem = UITabBarItem(title: "logout", image: nil, tag: 2)
        let logoutBar = UINavigationController(rootViewController: logoutView)

        setViewControllers([homeBar, logoutBar], animated: false)
    }
}

extension TabBarViewController {
    static func createinstance() -> TabBarViewController {
        let instance = TabBarViewController()
        return instance
    }
}
