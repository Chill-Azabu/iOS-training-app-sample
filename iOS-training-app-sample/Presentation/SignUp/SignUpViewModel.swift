//
//  SignupViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SignUpViewModel: ViewModel {
    typealias Input = (
        email: Driver<String>,
        password: Driver<String>,
        passwordConf: Driver<String>,
        signUpTap: Signal<Void>
    )
    typealias Dependency = (
        UserAccountRepositoryImpl
    )
    var disposeBag: DisposeBag { get }
    var isValid: Driver<Bool> { get }
    var responseError: BehaviorRelay<Error?> { get }
    var didSignUpTap: PublishRelay<Void> { get }
}

final class SignUpViewModelImpl: SignUpViewModel {

    private let dependency: Dependency
    private let isEmailValid: Driver<Bool>
    private let isPasswordValid: Driver<Bool>
    private let isPasswordConfValid: Driver<Bool>

    let disposeBag: DisposeBag
    let isValid: Driver<Bool>
    let responseError: BehaviorRelay<Error?>
    let didSignUpTap: PublishRelay<Void>

    init(input: Input, dependency: Dependency) {
        self.disposeBag = DisposeBag()
        self.dependency = dependency
        self.responseError = BehaviorRelay<Error?>(value: nil)
        self.didSignUpTap = PublishRelay<Void>()

        self.isEmailValid = input.email
            .map { text in text.count >= 3 }.asDriver()

        self.isPasswordValid = input.password
            .map { text in text.count >= 6 }.asDriver()

        self.isPasswordConfValid = input.password
            .map { text in text.count >= 6 }.asDriver()

        self.isValid = Driver.combineLatest(isPasswordValid, isPasswordValid) { $0 && $1 }
        let signUpParameter = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }

        let results = input.signUpTap
            .asObservable()
            .withLatestFrom(signUpParameter)
            .flatMapLatest { params in
                dependency.signUp(email: params.email, password: params.password)
                .asObservable().materialize()
            }.share(replay: 1)

        _ = results
            .elements()
            .subscribe(onNext: { [unowned self] _ in
                self.didSignUpTap.accept(())
            })

        _ = results
            .errors()
            .subscribe(onNext: { [unowned self] error in
                self.responseError.accept(error)
            })
    }
}
