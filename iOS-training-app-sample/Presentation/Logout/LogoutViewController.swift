//
//  LogoutViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LogoutViewController: UIViewController, ViewController {

    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            logoutButton.setTitle("ログアウト", for: .normal)
        }
    }
    
    private lazy var viewModel = LogoutViewModelImpl(
        logoutButtonTap: logoutButton.rx.tap.asSignal(),
        dependency: UserAccountRepositoryImpl()
    )
    private let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Palette.yellow
        title = "設定"

        viewModel.responseError.skip(1)
            .subscribe(onNext: { [unowned self] _ in
                self.showAlertDialog(title: "error", message: "confirm error")
            })
            .disposed(by: disposeBag)

        viewModel.didLogoutTap
            .subscribe(onNext: { [unowned self] _ in
                let nc = UINavigationController(rootViewController: SignInViewController.createInstance())
                AppDelegate.shared.window?.rootViewController = nc
            })
            .disposed(by: disposeBag)
    }
}

extension LogoutViewController {
    static func createInstance() -> LogoutViewController {
        let instance = R.storyboard.logoutViewController.logoutViewController()!
        return instance
    }
}

