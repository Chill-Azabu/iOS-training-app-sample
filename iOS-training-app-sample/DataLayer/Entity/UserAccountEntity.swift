//
//  UserAccountEntity.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation

struct UserAccountEntity: Decodable {

    let status: Int
    let result: Response

    struct Response: Decodable {
        let id: Int
        let email: String
        let token: String
    }
}
