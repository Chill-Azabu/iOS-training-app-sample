//
//  dataStore.swift
//  iOS-training-app-sampleTests
//
//  Created by Iichiro Kawashima on 2019/06/23.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import XCTest
import RxSwift
import APIKit

@testable import iOS_training_app_sample

class dataStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let dataStore = ContentsDataStoreImpl()
        let disposeBag = DisposeBag()

        let exp = expectation(description: "success")

        dataStore.fetchContentsList(limit: 1, page: 1)
            .subscribe(onSuccess: { _ in
                exp.fulfill()
            }, onError: { error in
                XCTAssert(false, error.localizedDescription)
            }).disposed(by: disposeBag)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
