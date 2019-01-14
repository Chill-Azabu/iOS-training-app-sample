//
//  ContentsViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol ContentsEditViewModel: ViewModel {
    typealias Input = (
        image: UIImage,
        title: Driver<String>,
        price: Driver<String>,
        purchaseDate: Driver<String>,
        saveButtonTap: Signal<Void>
    )
    typealias Dependency = (
        ContentsRepositoryImpl
    )
    var didRequestEnd: PublishRelay<Void> { get }
    var responseError: BehaviorRelay<Error?> { get }
}

final class ContentsEditViewModelImpl: ContentsEditViewModel {
    let didRequestEnd: PublishRelay<Void>
    let responseError: BehaviorRelay<Error?>

    init(input: Input, dependency: Dependency) {
        self.didRequestEnd = PublishRelay<Void>()
        self.responseError = BehaviorRelay<Error?>(value: nil)

        guard let imageData: Data = input.image.pngData() else { return }
        let imageDataString: String = imageData.base64EncodedString(options: [])

        let price = input.price
            .map { price -> Int in
                guard let price = Int(price) else { return 0 }
                return price
            }.asDriver()

        let purchaseDate = input.purchaseDate
            .map { date -> (String) in
                date.replacingOccurrences(of: "/", with: "-")
                return date
            }.asDriver()

        let parameters = Driver.combineLatest(input.title, price, purchaseDate) { ( name: $0, price: $1, purchaceDate: $2) }

        let results = input.saveButtonTap
            .asObservable()
            .withLatestFrom(parameters)
            .flatMapLatest { params in
                dependency.editContents(id: 2, image: imageDataString, name: params.name, price: params.price, purchaseDate: params.purchaceDate)
                    .asObservable().materialize()
            }.share(replay: 1)

        _ = results
            .elements()
            .subscribe(onNext: { [unowned self] _ in
                self.didRequestEnd.accept(())
            })

        _ = results
            .errors()
            .subscribe(onNext: { [unowned self] error in
                self.responseError.accept(error)
            })
    }
}
