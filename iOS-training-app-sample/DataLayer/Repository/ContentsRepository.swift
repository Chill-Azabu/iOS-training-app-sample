//
//  ContentsRepository.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import APIKit
import RxSwift
import Result

// Contents関連のデータ操作
protocol ContentsRepository {
    func fetchContentsList(limit: Int, page: Int) -> Single<ContentsListEntity>
    func addContents(image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity>
    func editContents(id: Int, image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity>
}

final class ContentsRepositoryImpl: ContentsRepository {

    private let dataStore: ContentsDataStore = ContentsDataStoreImpl()

    func fetchContentsList(limit: Int, page: Int) -> Single<ContentsListEntity> {
        return dataStore.fetchContentsList(limit: limit, page: page)
    }

    func addContents(image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity> {
        return dataStore.postContents(image: image, name: name, price: price, purchaseDate: purchaseDate)
    }

    func editContents(id: Int, image: String, name: String, price: Int, purchaseDate: String) -> Single<ContentsRegisterEntity> {
        return dataStore.patchContents(id: id, image: image, name: name, price: price, purchaseDate: purchaseDate)
    }
}
