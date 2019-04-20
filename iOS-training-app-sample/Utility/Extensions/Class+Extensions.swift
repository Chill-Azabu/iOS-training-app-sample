//
//  Class+Extensions.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/13.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }
}
