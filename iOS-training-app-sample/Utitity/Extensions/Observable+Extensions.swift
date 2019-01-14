//
//  Observable+Extensions.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/11.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E: EventConvertible {
    public func elements() -> Observable<E.ElementType> {
        return filter { $0.event.element != nil }
            .map { $0.event.element! }
    }
    public func errors() -> Observable<Swift.Error> {
        return filter { $0.event.error != nil }
            .map { $0.event.error! }
    }
}
