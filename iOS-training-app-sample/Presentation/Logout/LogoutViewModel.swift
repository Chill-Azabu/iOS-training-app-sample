//
//  LogoutViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LogoutViewModel: ViewModel {
    typealias Dependency = (
        UserAccountRepositoryImpl
    )
    var disposeBag: DisposeBag { get }
    var responseError: BehaviorRelay<Error?> { get }
    var didLogoutTap: PublishRelay<Void> { get }
}

final class LogoutViewModelImpl: LogoutViewModel {

    private let dependency: Dependency
    let disposeBag: DisposeBag
    let responseError: BehaviorRelay<Error?>
    let didLogoutTap: PublishRelay<Void>
    
    init(logoutButtonTap: Signal<Void>, dependency: Dependency) {
        self.dependency = dependency
        self.disposeBag = DisposeBag()
        self.responseError = BehaviorRelay<Error?>(value: nil)
        self.didLogoutTap = PublishRelay<Void>()

        let results = logoutButtonTap
            .asObservable()
            .flatMapLatest {
                dependency.logout()
                .asObservable().materialize()
            }.share(replay: 1)

        _ = results
            .elements()
            .subscribe(onNext: { [unowned self] _ in
                self.didLogoutTap.accept(())
            })

        _ = results
            .errors()
            .subscribe(onNext: { [unowned self] error in
                self.responseError.accept(error)
            })
    }
}
