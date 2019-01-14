//
//  FontSize.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/13.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation

// structよりもenumの方が堅牢
enum Font: Int {
    case size12
    case size13
    case size14
    case size15

    var size: Int {
        switch self {
        case .size12:
            return 12
        case .size13:
            return 13
        case .size14:
            return 14
        case .size15:
            return 15
        }
    }
}
