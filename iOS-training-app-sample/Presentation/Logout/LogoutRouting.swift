//
//  LogoutRouting.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/06.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit

protocol LogoutRouting: Routing {
    func showSignIn()
}

final class LogoutRoutingImpl: LogoutRouting {

    weak var viewController: UIViewController?

    func showSignIn() {
        let vc = SignInViewController.createInstance()
        let nc = UINavigationController(rootViewController: vc)
        AppDelegate.shared.window?.rootViewController = nc
    }
}
