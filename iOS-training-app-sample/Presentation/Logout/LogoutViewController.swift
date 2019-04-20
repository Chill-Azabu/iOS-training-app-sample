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
    
    private lazy var viewModel: LogoutViewModelImpl = {
        let viewModel = LogoutViewModelImpl(logoutButtonTap: logoutButton.rx.tap.asSignal(),
                                                 dependency: UserAccountRepositoryImpl()
        )
        return viewModel
    }()

    private var routing: LogoutRouting! {
        didSet {
            routing.viewController = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppResource.Color.gray
        navigationController?.navigationBar.barTintColor = AppResource.Color.lightGray
        title = "設定"

        self.bindView()
    }

    private func bindView() {
        viewModel.responseError.skip(1)
            .subscribe(onNext: { [unowned self] _ in
                self.showAlertDialog(title: "error", message: "confirm error")
            })
            .disposed(by: viewModel.disposeBag)

        viewModel.didLogoutTap
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showSignIn()
            })
            .disposed(by: viewModel.disposeBag)
        
    }
}

extension LogoutViewController {
    static func createInstance() -> LogoutViewController {
        let instance = R.storyboard.logoutViewController.logoutViewController()!
        instance.routing = LogoutRoutingImpl()
        return instance
    }
}
