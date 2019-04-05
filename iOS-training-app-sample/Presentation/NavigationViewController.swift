//
//  NavigationViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/23.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    private var statusBarStyle = UIStatusBarStyle.default
    private var statusBarHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        statusBarStyle  = viewController.preferredStatusBarStyle
        statusBarHidden = viewController.prefersStatusBarHidden
        setNeedsStatusBarAppearanceUpdate()
    }
}
