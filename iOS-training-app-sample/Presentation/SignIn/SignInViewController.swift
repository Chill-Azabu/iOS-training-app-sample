//
//  SignInViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxSwift

class SignInViewController: UIViewController, ViewController {

    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.text = "メールアドレス"
            emailLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = "入力する"
        }
    }

    @IBOutlet weak var passwordLabel: UILabel! {
        didSet {
            passwordLabel.text = "パスワード"
            passwordLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = "入力する"
            passwordTextField.isSecureTextEntry = true
        }
    }

    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.setTitle("ログイン", for: .normal)
            signInButton.backgroundColor = .lightGray
        }
    }

    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.setTitle("新規作成", for: .normal)
            signUpButton.backgroundColor = .lightGray
        }
    }

    private let disposeBag: DisposeBag = .init()
    private lazy var viewModel = SignInViewModelImpl(
        input: (
            email: emailTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            signInTap: signInButton.rx.tap.asSignal()
        ),
        dependency: (UserAccountRepositoryImpl())
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Palette.yellow
        title = "書籍一覧"

        bindView()
    }

    private func bindView() {

        viewModel.isValid
            .drive(onNext: { [unowned self] valid in
                self.signInButton.isEnabled = valid
                self.signInButton.backgroundColor = valid ? .lightGray : .green
            })
            .disposed(by: disposeBag)

        viewModel.didSignInTap
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.pushViewController(TabBarViewController(), animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.responseError.skip(1)
            .subscribe(onNext: { [unowned self] error in
                self.showAlertDialog(title: "エラー", message: (error?.localizedDescription)!)
            }).disposed(by: disposeBag)

        signUpButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let vc = SignUpViewController.createInstance()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SignInViewController {
    static func createInstance() -> SignInViewController {
        let instance = R.storyboard.signInViewController.signInViewController()!
        return instance
    }
}
