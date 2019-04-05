//
//  AddContentsAPI.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import Foundation

final class AddContenstsAPI {
    struct Request: AppRequestType {
        typealias Response = ContentsRegisterEntity

        let image: String
        let name: String
        let price: Int
        let purchaseDate: String

        var method: HTTPMethod {
            return APIRoutes.addContents.configurePath().method
        }

        var path: String {
            return APIRoutes.addContents.configurePath().path
        }

        var headerFields: [String: String] {
            return ["Authorization": AppUserDefaults.getToken()]
        }

        var bodyParameters: BodyParameters? {
            return JSONBodyParameters(JSONObject: [
                "image": image,
                "name": name,
                "price": price,
                "purchase_date": purchaseDate
                ])
        }
    }
}
