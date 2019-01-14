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

    private lazy var viewModel = SplashViewModelImpl()
    private let disposebag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.Palette.yellow

        logoImageView.alpha = 0.0
        UIView.animate(withDuration: 1.5, animations: { [unowned self] in
            self.logoImageView.alpha = 1.0
            }, completion: { [unowned self] finished in
                self.bind()
        })
    }
    
    private func bind() {
        viewModel.launchPath
            .subscribe(onNext: { [unowned self] path in
                switch path {
                case .signUp:
                    let nc = UINavigationController(rootViewController: SignUpViewController.createInstance())
                    self.present(nc, animated: true)
                case .signIn:
                    let nc = UINavigationController(rootViewController: SignInViewController.createInstance())
                    self.present(nc, animated: true)
                case .home:
                    self.navigationController?.pushViewController(TabBarViewController(), animated: true)
                }
            })
            .disposed(by: disposebag)
    }
}

extension SplashViewController {
    static func createInstance() -> SplashViewController {
        let instance = R.storyboard.splashViewController.splashViewController()!
        return instance
    }
}
