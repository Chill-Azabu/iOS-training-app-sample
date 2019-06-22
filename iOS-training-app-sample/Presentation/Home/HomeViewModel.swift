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
    var contentsList: PublishRelay<[HomeTableViewCell.ViewData]> { get }
}

final class HomeViewModelImpl: HomeViewModel {

    private var page = 0

    let responseError: BehaviorRelay<Error?>
    let disposeBag: DisposeBag
    let contentsList: PublishRelay<[HomeTableViewCell.ViewData]>

    init(input: Input, dependency: Dependency) {
        self.disposeBag = DisposeBag()
        self.responseError = BehaviorRelay<Error?>(value: nil)
        self.contentsList = PublishRelay<[HomeTableViewCell.ViewData]>()

        let results = input
            .do { [weak self] in
                self?.page += 1
            }
            .flatMapLatest { [weak self] in
                dependency.fetchContentsList(limit: AppResource.Const.limit, page: self?.page ?? 1)
                .asObservable().materialize()
            }.share(replay: 1)

        _ = results
            .elements()
            .map { results -> [HomeTableViewCell.ViewData] in
                guard let item = results.result.first else { return [] }
                let items: [HomeTableViewCell.ViewData] = [HomeTableViewCell.ViewData.init(name: item.name, price: item.price, image: item.image, purchaseDate: item.purchaseDate)]
                return items
            }
            .subscribe(onNext: { [unowned self] results in
                self.contentsList.accept (results)
            })

        _ = results
            .errors()
            .subscribe(onNext: { [unowned self] error in
                self.responseError.accept(error)
            })
    }
}
