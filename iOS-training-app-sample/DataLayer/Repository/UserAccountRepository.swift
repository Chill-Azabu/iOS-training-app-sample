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
    func signIn(email: String, password: String) -> Single<UserAccountEntity>
    func signUp(email: String, password: String) -> Single<UserAccountEntity>
    func logout() -> Single<LogoutEntity>
}

final class UserAccountRepositoryImpl: UserAccountRepository {

    private let dataStore: UserAccountDataStore = UserAccountDataStoreImpl()

    func signIn(email: String, password: String) -> Single<UserAccountEntity> {
        return dataStore.signIn(email: email, password: password)
            .do(onSuccess: { response in
                AppUserDefaults.setToken(token: response.result.token)
            })
    }

    func signUp(email: String, password: String) -> Single<UserAccountEntity> {
        return dataStore.signUp(email: email, password: password)
            .do(onSuccess: { response in
                AppUserDefaults.setToken(token: response.result.token)
            })
    }

    func logout() -> Single<LogoutEntity> {
        return dataStore.logout()
            .do(onSuccess: { _ in
                AppUserDefaults.clearAuthToken()
            })
    }
}
