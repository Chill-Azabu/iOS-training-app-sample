//
//  HomeViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModel: ViewModel {
    typealias Input = (
        Observable<Void>
    )

    typealias Dependency = (
        ContentsRepositoryImpl
    )
    var disposeBag: DisposeBag { get }
    var responseError: BehaviorRelay<Error?> { get }
}

final class HomeViewModelImpl: HomeViewModel {
    let responseError: BehaviorRelay<Error?>
    let disposeBag: DisposeBag
    let contentsList: PublishRelay<[ContentsListEntity]>

    init(input: Input, dependency: Dependency) {
        self.disposeBag = DisposeBag()
        self.responseError = BehaviorRelay<Error?>(value: nil)
        self.contentsList = PublishRelay<[ContentsListEntity]>()

        let results = input
            .flatMapLatest {
                dependency.fetchContentsList(limit: 1, page: 10)
                .asObservable().materialize()
            }.share(replay: 1)

        _ = results
            .elements()
            .subscribe(onNext: { [unowned self] results in
                self.contentsList.accept ([results])
            })

        _ = results
            .errors()
            .subscribe(onNext: { [unowned self] error in
                self.responseError.accept(error)
            })
    }
}
