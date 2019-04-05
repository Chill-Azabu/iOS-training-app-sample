//
//  UserAccountDataStore.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import Result
import RxSwift

// ユーザーアカウント関連のデータ取得
protocol UserAccountDataStore {
    func signIn(email: String, password: String) -> Single<UserAccountEntity>
    func signUp(email: String, password: String) -> Single<UserAccountEntity>
    func logout() -> Single<LogoutEntity>
}

final class UserAccountDataStoreImpl: UserAccountDataStore {
    func signIn(email: String, password: String) -> Single<UserAccountEntity> {
        let request = SignInAPI.Request(email: email, password: password)
        return Session.rx_sendRequest(request: request)
    }

    func signUp(email: String, password: String) -> Single<UserAccountEntity> {
        let request = SignUpAPI.Request(email: email, password: password)
        return Session.rx_sendRequest(request: request)
    }

    func logout() -> Single<LogoutEntity> {
        let request = LogpoutAPI.Request()
        return Session.rx_sendRequest(request: request)
    }
}
