//
//  EditContentsAPI.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import Foundation

final class EditContenstsAPI {
    struct Request: AppRequestType {
        typealias Response = ContentsRegisterEntity.Response

        let id: Int
        let image: String
        let name: String
        let price: Int
        let purchaseDate: String

        var method: HTTPMethod {
            return APIRoutes.editContents.configurePath().method
        }

        var path: String {
            return APIRoutes.editContents.configurePath().path + "\(id)"
        }

        var headerFields: [String: String] {
            return ["Authorization": AppUserDefaults.getToken()]
        }

        var bodyParameters: BodyParameters? {
            return JSONBodyParameters(JSONObject: [
                "id": id,
                "image": image,
                "name": name,
                "price": price,
                "purchase_date": purchaseDate
                ])
        }
    }
}
