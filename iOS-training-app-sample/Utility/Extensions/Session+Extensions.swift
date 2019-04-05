//
//  Session+Extensions.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import RxSwift

extension Session {
    func rx_sendRequest<T: Request>(request: T) -> Single<T.Response> {
        return Single.create { observer in
            let task = self.send(request) { result in
                switch result {
                case .success(let res):
                    observer(.success(res))
                case .failure(let err):
                    observer(.error(err))
                }
            }
            return Disposables.create { [weak task] in
                task?.cancel()
            }
        }
    }

    class func rx_sendRequest<T: Request>(request: T) -> Single<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
}

extension PrimitiveSequence where TraitType == SingleTrait {
    public func asMaybe() -> PrimitiveSequence<MaybeTrait, Element> {
        return self.asObservable().asMaybe()
    }

    public func asCompletable() -> PrimitiveSequence<CompletableTrait, Never> {
        return self.asObservable().flatMap { _ in Observable<Never>.empty() }.asCompletable()
    }
}

extension PrimitiveSequence where TraitType == CompletableTrait, ElementType == Swift.Never {
    public func asMaybe() -> PrimitiveSequence<MaybeTrait, Element> {
        return self.asObservable().asMaybe()
    }
}
