//
//  SignUpViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController, ViewController {

    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.text = "メールアドレス"
            emailLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = "入力してください"
            emailTextField.clearButtonMode = .whileEditing
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
            passwordTextField.placeholder = "入力してください"
            passwordTextField.isSecureTextEntry = true
            emailTextField.clearButtonMode = .whileEditing
        }
    }

    @IBOutlet weak var passwordConfLabel: UILabel! {
        didSet {
            passwordConfLabel.text = "パスワード確認"
            passwordConfLabel.textAlignment = .left
        }
    }
    
    @IBOutlet weak var passwordConfTextField: UITextField! {
        didSet {
            passwordConfTextField.placeholder = "入力してください"
            passwordConfTextField.isSecureTextEntry = true
            passwordConfTextField.clearButtonMode = .whileEditing
        }
    }
    
    private let saveButton: UIBarButtonItem = {
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: nil)
        return saveButton
    }()

    private let closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: nil)
        return closeButton
    }()

    private var viewModel: SignUpViewModel!
    private var routing: SignUpRouting!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Palette.gray
        navigationController?.navigationBar.barTintColor = Color.Palette.lightGray
        setupNavBar()

        bindView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupNavBar() {
        title = "アカウント設定"
        navigationItem.setRightBarButton(saveButton, animated: true)
        navigationItem.setLeftBarButton(closeButton, animated: true)
    }

    private func bindView() {

        viewModel.isValid
            .drive(onNext: { [unowned self] valid in
                self.saveButton.isEnabled = valid
                self.saveButton.tintColor = valid ? .blue : .lightGray
            })
            .disposed(by: viewModel.disposeBag)

        viewModel.didSignUpTap
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showHome()
            }).disposed(by: viewModel.disposeBag)

        viewModel.responseError.skip(1)
            .subscribe(onNext: { [unowned self] error in
                self.showAlertDialog(title: "エラー", message: (error?.localizedDescription)!)
            }).disposed(by: viewModel.disposeBag)

        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showSignIn()
            }).disposed(by: viewModel.disposeBag)
    }
}

extension SignUpViewController {
    static func createInstance() -> SignUpViewController {
        let instance = R.storyboard.signUpViewController.signUpViewController()!
        instance.viewModel = SignUpViewModelImpl(
            input: (
                email: instance.emailTextField.rx.text.orEmpty.asDriver(),
                password: instance.passwordTextField.rx.text.orEmpty.asDriver(),
                passwordConf: instance.passwordConfTextField.rx.text.orEmpty.asDriver(),
                signUpTap: instance.saveButton.rx.tap.asSignal()
            ),
            dependency: (UserAccountRepositoryImpl())
        )
        instance.routing = SignUpRoutingImpl()
        return instance
    }
}
