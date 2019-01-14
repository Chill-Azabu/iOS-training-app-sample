//
//  AppuserDefaults.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import KeychainAccess

class AppUserDefaults {

    // 初回起動フラグ
    static func getFirstLaunchFrag() -> Bool {
        return getBoolValue(keyName: "FirstLaunch")
    }

    static func setFirstLaunchFrag() {
        putBoolValue(true, keyName: "FirstLaunch")
    }

    // ログインフラグ
    static func getToken() -> String {
        return getStringValue(keyName: "auth_token")
    }

    static func setToken(token: String) {
        putStringValue(token, keyName: "auth_token")
    }

    static func isLogin() -> Bool {
        if getToken().isEmpty {
            return false
        }
        return true
    }

    static func clearAuthToken() {
        putStringValue("", keyName: "auth_token")
    }
}

extension AppUserDefaults {
    static func getBoolValue(keyName: String) -> Bool {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: keyName)
    }

    static func putBoolValue(_ value: Bool, keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
        userDefaults.synchronize()
    }

    static func getStringValue(keyName: String) -> String {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.string(forKey: keyName) ?? ""
    }

    static func putStringValue(_ value: String, keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
        userDefaults.synchronize()
    }
}
