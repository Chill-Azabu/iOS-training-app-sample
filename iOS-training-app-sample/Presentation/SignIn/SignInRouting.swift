//
//  SignInRouting.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/06.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit

protocol SignInRouting: Routing {
    func showSignUp()
    func showHome()
}

final class SignInRoutingImpl: SignInRouting {
    weak var viewController: UIViewController?

    func showSignUp() {
        let vc = SignUpViewController.createInstance()
        viewController?.navigationController?.pushViewController(vc, animated: false)
    }

    func showHome() {
        let tabVC = TabBarViewController()
        viewController?.navigationController?.pushViewController(tabVC, animated: false)
    }
}
