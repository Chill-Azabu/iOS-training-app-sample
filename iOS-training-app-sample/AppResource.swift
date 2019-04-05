//
//  Const.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import UIKit

struct AppResource {
    struct Screen {
        static let Bounds = UIScreen.main.bounds
        static let Width = UIScreen.main.bounds.width
        static let Height = UIScreen.main.bounds.height
        static let StatusBarHeight = UIApplication.shared.statusBarFrame.height
        static let StatusBarWidth = UIApplication.shared.statusBarFrame.width
    }

    struct Color {
        /// #F26161
        static let coral = #colorLiteral(red: 0.9490196078, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
        /// #41424E
        static let black = #colorLiteral(red: 0.2549019608, green: 0.2588235294, blue: 0.3058823529, alpha: 1)
        /// #828290
        static let gray = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5647058824, alpha: 1)
        /// #DADBE3
        static let lightGray = #colorLiteral(red: 0.8549019608, green: 0.8588235294, blue: 0.8901960784, alpha: 1)
        /// #F7F8FA
        static let snowWhite = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
        /// #1EBD7D
        static let green = #colorLiteral(red: 0.1176470588, green: 0.7411764706, blue: 0.4901960784, alpha: 1)
        /// #FFB44A
        static let yellow = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.2901960784, alpha: 1)
        /// #6585C2
        static let blue = #colorLiteral(red: 0.3960784314, green: 0.5215686275, blue: 0.7607843137, alpha: 1)
    }

    struct Const {
        static let Version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        static let OSVersion = UIDevice.current.systemVersion
        static let Model = UIDevice.current.model
        static let url = "http://54.250.239.8"
        static let token = "token"
    }
}