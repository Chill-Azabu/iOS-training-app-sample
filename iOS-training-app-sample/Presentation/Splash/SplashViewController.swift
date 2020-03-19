//
//  SplashViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxSwift

class SplashViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.image = R.image.caraquri_logo()
        }
    }

    private var viewModel: SplashViewModel!
    private var routing: SplashRouting! {
        didSet {
            routing.viewController = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppResource.Color.yellow

        logoImageView.alpha = 0.0
        UIView.animate(withDuration: 1.5, animations: { [unowned self] in
            self.logoImageView.alpha = 1.0
            }, completion: { _ in
                self.bindView()
        })
    }
    
    private func bindView() {
        viewModel.launchPath
            .subscribe(onNext: { [unowned self] path in
                switch path {
                case .signUp:
                    self.routing.showSignUp()
                case .signIn:
                    self.routing.showSignIn()
                case .home:
                    self.routing.showHome()
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}

extension SplashViewController {
    static func createInstance() -> SplashViewController {
        let instance = R.storyboard.splashViewController.splashViewController()!
        instance.viewModel = SplashViewModelImpl()
        instance.routing = SplashRoutingImpl()
        return instance
    }
}
