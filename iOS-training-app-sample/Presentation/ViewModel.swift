//
//  ViewModel.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import RxCocoa

// ViewModelで共通して使用する処理をまとめる
protocol ViewModel {
    var responseError: BehaviorRelay<Error?> { get }
}
