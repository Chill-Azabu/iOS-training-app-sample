//
//  UserAccountRepository.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import RxSwift
import Result

// ユーザーアカウント関連のデータ操作
protocol UserAccountRepository {
    func signIn(email: String, password: String) -> Single<UserAccountEntity.Response>
    func signUp(email: String, password: String) -> Single<UserAccountEntity.Response>
    func logout() -> Single<LogoutEntity>
}

final class UserAccountRepositoryImpl: UserAccountRepository {
    static let shared: UserAccountRepository  = UserAccountRepositoryImpl()

    private let dataStore: UserAccountDataStore = UserAccountDataStoreImpl()

    func signIn(email: String, password: String) -> Single<UserAccountEntity.Response> {
        return dataStore.signIn(email: email, password: password)
            .do(onSuccess: { result in
                AppUserDefaults.putStringValue(result.token, keyName: "token")
            })
    }

    func signUp(email: String, password: String) -> Single<UserAccountEntity.Response> {
        return dataStore.signUp(email: email, password: password)
    }

    func logout() -> Single<LogoutEntity> {
        return dataStore.logout()
    }
}
