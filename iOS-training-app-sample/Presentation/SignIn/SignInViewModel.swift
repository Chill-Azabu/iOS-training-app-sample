//
//  SignInViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SignInViewModel: ViewModel {
    typealias Input = (
        email: Driver<String>,
        password: Driver<String>,
        signInTap: Signal<Void>
    )
    typealias Dependency = (
        UserAccountRepositoryImpl
    )

    var isValid: Driver<Bool> { get }
    var responseError: BehaviorRelay<Error?> { get }
    var didSignInTap: PublishRelay<Void> { get }
}

final class SignInViewModelImpl: SignInViewModel {

    private let dependency: Dependency
    private let isEmailValid: Driver<Bool>
    private let isPasswordValid: Driver<Bool>

    let isValid: Driver<Bool>
    let responseError: BehaviorRelay<Error?>
    let didSignInTap: PublishRelay<Void>

    init(input: Input, dependency: Dependency) {
        self.dependency = dependency
        self.responseError = BehaviorRelay<Error?>(value: nil)
        self.didSignInTap = PublishRelay<Void>()

        self.isEmailValid = input.email
            .map { text in
                text.count >= 3
            }.asDriver()

        self.isPasswordValid = input.password
            .map { text  in
                text.count >= 6
            }.asDriver()

        self.isValid = Driver.combineLatest(isEmailValid, isPasswordValid) { $0 && $1 }
        let signInParameter = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }

        let results = input.signInTap
            .asObservable()
            .withLatestFrom(signInParameter)
            .flatMapLatest { params in
                dependency.signIn(email: params.email, password: params.password)
                .asObservable().materialize()
            }.share(replay: 1)

        _ = results
            .elements()
            .subscribe(onNext: { [unowned self] _ in
                self.didSignInTap.accept(())
            })

        _ = results
            .errors()
            .subscribe(onNext: { [unowned self] error in
                self.responseError.accept(error)
            })
    }
}
