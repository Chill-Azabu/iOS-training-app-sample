//
//  ContentsDataStore.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import RxSwift
import Result

// Contents関連のデータ操作
protocol ContentsDataStore {
    func fetchContentsList(limit: Int, page: Int) -> Single<ContentsListEntity.Response>
    func addContents(image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity.Response>
    func editContents(id: Int, image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity.Response>
}

final class ContentsDataStoreImpl: ContentsDataStore {

    var responseArray: [ContentsListEntity.Response] = []

    func fetchContentsList(limit: Int, page: Int) -> Single<ContentsListEntity.Response> {
        let request = FetchContenstsListAPI.Request(limit: limit, page: page)
        return Session.rx_sendRequest(request: request)
            .do(onSuccess: { [weak self] response in
                self?.responseArray.append(response)
            })
    }

    func addContents(image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity.Response> {
        let request = AddContenstsAPI.Request(image: image, name: name, price: price, purchaseDate: purchaseDate)
        return Session.rx_sendRequest(request: request)
    }

    func editContents(id: Int, image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity.Response> {
        let request = EditContenstsAPI.Request(id: id, image: image, name: name, price: price, purchaseDate: purchaseDate)
        return Session.rx_sendRequest(request: request)
    }
}
