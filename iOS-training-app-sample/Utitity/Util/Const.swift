//
//  Const.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import UIKit

struct Const {
    struct Screen {
        static let Bounds = UIScreen.main.bounds
        static let Width = UIScreen.main.bounds.width
        static let Height = UIScreen.main.bounds.height
        static let StatusBarHeight = UIApplication.shared.statusBarFrame.height
        static let StatusBarWidth = UIApplication.shared.statusBarFrame.width
    }

    struct App {
        static let Version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        static let OSVersion = UIDevice.current.systemVersion
        static let Model = UIDevice.current.model
    }

    static let url = "http://54.250.239.8"
}
