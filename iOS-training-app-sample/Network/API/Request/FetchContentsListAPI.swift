//
//  ContentsAPI.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import Foundation

final class FetchContenstsListAPI {
    struct Request: AppRequestType {
        typealias Response = ContentsListEntity.Response

        let limit: Int
        let page: Int

        var method: HTTPMethod {
            return APIRoutes.fetchContenstsList.configurePath().method
        }

        var path: String {
            return APIRoutes.fetchContenstsList.configurePath().path
        }

        var headerFields: [String: String] {
            return ["Authorization": AppUserDefaults.getToken()]
        }

        var parameters: Any? {
            return [
                "limit": limit,
                "page": page
            ]
        }
    }
}
