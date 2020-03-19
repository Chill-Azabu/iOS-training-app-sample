//
//  SplashViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/13.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum LaunchPath {
    case signIn, signUp, home
}

protocol SplashViewModel {
    var disposeBag: DisposeBag { get }
    var launchPath: BehaviorRelay<LaunchPath> { get }
}

final class SplashViewModelImpl: SplashViewModel {

    let disposeBag: DisposeBag
    let launchPath: BehaviorRelay<LaunchPath>

    init() {
        self.disposeBag = DisposeBag()
        self.launchPath = BehaviorRelay<LaunchPath>(value: .signIn)
        self.validateScreenPath()
    }

    private func validateScreenPath() {
        if !AppUserDefaults.getFirstLaunchFrag() {
            AppUserDefaults.setFirstLaunchFrag()
            self.launchPath.accept(.signUp)
        } else if AppUserDefaults.isLogin() {
            self.launchPath.accept(.home)
        }
        self.launchPath.accept(.signIn)
    }
}
