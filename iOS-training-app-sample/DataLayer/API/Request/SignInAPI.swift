//
//  UserAccountAPI.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import Foundation

final class SignInAPI {
    struct Request: AppRequestType {
        typealias Response = UserAccountEntity

        // メールアドレス
        let email: String
        // パスワード
        let password: String

        var method: HTTPMethod {
            return APIRoutes.signIn.configurePath().method
        }

        var path: String {
            return APIRoutes.signIn.configurePath().path
        }

        var bodyParameters: BodyParameters? {
            return JSONBodyParameters(JSONObject: [
                "email": email,
                "password": password
                ])
        }
    }
}
