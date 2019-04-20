//
//  ContentsAddViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol ContentsAddViewModel: ViewModel {
    typealias Input = (
        title: Driver<String>,
        price: Driver<String>,
        purchaseDate: Driver<String>,
        saveButtonTap: Signal<Void>
    )
    typealias Dependency = (
        ContentsRepositoryImpl
    )
    var disposeBag: DisposeBag { get }
    var didEnd: PublishRelay<Void> { get }
    var responseError: BehaviorRelay<Error?> { get }
    var imageView: Driver<UIImage> { get }
}

final class ContentsAddViewModelImpl: ContentsAddViewModel {
    let disposeBag: DisposeBag
    let didEnd: PublishRelay<Void>
    let responseError: BehaviorRelay<Error?>
    let imageView: Driver<UIImage>

    init(input: Input, dependency: Dependency) {
        self.disposeBag = DisposeBag()
        self.didEnd = PublishRelay<Void>()
        self.responseError = BehaviorRelay<Error?>(value: nil)
        self.imageView = Driver<UIImage>.never()

        let image = self.imageView.map { image -> String in
            guard let imageData: Data = image.pngData() else { return "" }
            let imageDataString: String = imageData.base64EncodedString(options: [])
            return imageDataString
        }

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

        let parameters = Driver.combineLatest(image, input.title, price, purchaseDate) { (image: $0, name: $1, price: $2, purchaceDate: $3) }

        let results = input.saveButtonTap
            .asObservable()
            .withLatestFrom(parameters)
            .flatMapLatest { params in
                dependency.addContents(image: params.image, name: params.name, price: params.price, purchaseDate: params.purchaceDate)
                    .asObservable().materialize()
            }.share(replay: 1)

        _ = results
            .elements()
            .subscribe(onNext: { [unowned self] _ in
                self.didEnd.accept(())
            })

        _ = results
            .errors()
            .subscribe(onNext: { [unowned self] error in
                self.responseError.accept(error)
            })
    }
}
