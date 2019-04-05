//
//  LogoutAPI.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import Foundation

final class LogpoutAPI {
    struct Request: AppRequestType {
        typealias Response = LogoutEntity
        
        var method: HTTPMethod {
            return APIRoutes.logout.configurePath().method
        }

        var path: String {
            return APIRoutes.logout.configurePath().path
        }
    }
}
