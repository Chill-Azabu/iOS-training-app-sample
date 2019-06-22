//
//  SplashRouting.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/06.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit

protocol SplashRouting: Routing {
    func showSignIn()
    func showSignUp()
    func showHome()
}

final class SplashRoutingImpl: SplashRouting {

    weak var viewController: UIViewController?

    func showSignIn() {
        let nc = UINavigationController(rootViewController: SignInViewController.createInstance())
        viewController?.present(nc, animated: true)
    }

    func showSignUp() {
        let nc = UINavigationController(rootViewController: SignUpViewController.createInstance())
        viewController?.present(nc, animated: true)
    }

    func showHome() {
        let tabVC = TabBarViewController()
        viewController?.navigationController?.present(tabVC, animated: false)
    }
}
