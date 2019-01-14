//
//  APIRoutes.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import Foundation

enum APIRoutes {
    case signIn
    case signUp
    case fetchContenstsList
    case addContents
    case editContents
    case logout

    // タプルで設定することで数字で指定せずに書ける。
    func configurePath() -> (method: HTTPMethod, path: String) {
        switch self {
        case .signIn:               return (.post, "login")
        case .signUp:               return (.post, "sign_up")
        case .fetchContenstsList:   return (.get, "books")
        case .addContents:          return (.post, "books")
        case .editContents:         return (.put, "books")
        case .logout:               return (.delete, "logout")
        }
    }
}
