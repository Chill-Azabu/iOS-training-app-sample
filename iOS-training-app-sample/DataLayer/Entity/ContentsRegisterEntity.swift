//
//  BookRegisterEntity.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation

struct ContentsRegisterEntity: Decodable {

    let status: Int
    let result: Response

    struct Response: Decodable {
        let id: Int
        let name: String
        let image: String
        let price: Int
        let purchaseDate: String

        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case image
            case price
            case purchaseDate = "purchase_date"
        }
    }
}
