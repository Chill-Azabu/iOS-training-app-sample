//
//  SignUpRouting.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/06.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit

protocol SignUpRouting: Routing {
    func showSignIn()
    func showHome()
}

final class SignUpRoutingImpl: SignUpRouting {
    weak var viewController: UIViewController?

    func showSignIn() {
        let vc = SignInViewController.createInstance()
        viewController?.navigationController?.popViewController(animated: false)
    }

    func showHome() {
        let tabVC = TabBarViewController.createinstance()
        viewController?.navigationController?.present(tabVC, animated: false)
    }
}
