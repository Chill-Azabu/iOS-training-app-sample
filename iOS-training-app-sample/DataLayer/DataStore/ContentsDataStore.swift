//
//  ContentsDataStore.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import RxSwift

// Contents関連のデータ操作
protocol ContentsDataStore {
    func fetchContentsList(limit: Int, page: Int) -> Single<ContentsListEntity>
    func postContents(image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity>
    func patchContents(id: Int, image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity>
}

final class ContentsDataStoreImpl: ContentsDataStore {

    func fetchContentsList(limit: Int, page: Int) -> Single<ContentsListEntity> {
        let request = FetchContenstsListAPI.Request(limit: limit, page: page)
        return Session.rx_sendRequest(request: request)
    }

    func postContents(image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity> {
        let request = AddContenstsAPI.Request(image: image, name: name, price: price, purchaseDate: purchaseDate)
        return Session.rx_sendRequest(request: request)
    }

    func patchContents(id: Int, image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity> {
        let request = EditContenstsAPI.Request(id: id, image: image, name: name, price: price, purchaseDate: purchaseDate)
        return Session.rx_sendRequest(request: request)
    }
}
