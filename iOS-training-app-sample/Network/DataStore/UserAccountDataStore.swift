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
    func signIn(email: String, password: String) -> Single<UserAccountEntity.Response>
    func signUp(email: String, password: String) -> Single<UserAccountEntity.Response>
    func logout() -> Single<LogoutEntity>
}

final class UserAccountDataStoreImpl: UserAccountDataStore {
    func signIn(email: String, password: String) -> Single<UserAccountEntity.Response> {
        let request = SignInAPI.Request(email: email, password: password)
        return Session.rx_sendRequest(request: request)
            .do(onSuccess: { response in
                AppUserDefaults.putStringValue(response.token, keyName: Const.token)
            })
    }

    func signUp(email: String, password: String) -> Single<UserAccountEntity.Response> {
        let request = SignUpAPI.Request(email: email, password: password)
        return Session.rx_sendRequest(request: request)
            .do(onSuccess: { response in
                AppUserDefaults.putStringValue(response.token, keyName: Const.token)
            })
    }

    func logout() -> Single<LogoutEntity> {
        let request = LogpoutAPI.Request()
        return Session.rx_sendRequest(request: request)
            .do(onSuccess: { _ in
                AppUserDefaults.clearAuthToken()
            })
    }
}
