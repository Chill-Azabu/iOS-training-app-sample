//
//  SplashViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/13.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxCocoa

enum LaunchPath: Int {
    case signIn
    case signUp
    case home
}

protocol SplashViewModel {
    func validate()
    var launchPath: BehaviorRelay<LaunchPath> { get }
}

final class SplashViewModelImpl: SplashViewModel {

    let launchPath: BehaviorRelay<LaunchPath>

    init() {
        self.launchPath = BehaviorRelay<LaunchPath>(value: .signIn)
        self.validate()
    }

    func validate() {
        if !AppUserDefaults.getFirstLaunchFrag() {
            AppUserDefaults.setFirstLaunchFrag()
            self.launchPath.accept(.signUp)
        } else if AppUserDefaults.isLogin() {
            self.launchPath.accept(.home)
        }
        self.launchPath.accept(.signIn)
    }
}
