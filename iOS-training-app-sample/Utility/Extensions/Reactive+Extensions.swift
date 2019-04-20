//
//  Reactive+Extensions.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/20.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//
import UIKit
import Foundation
import RxCocoa
import RxSwift

// https://github.com/ReactiveX/RxSwift/blob/master/RxExample/Extensions/UIImagePickerController%2BRx.swift
extension Reactive where Base: UIImagePickerController {

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
