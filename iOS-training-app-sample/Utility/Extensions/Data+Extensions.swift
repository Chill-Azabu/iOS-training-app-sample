//
//  Data+Extensions.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    static func convertToJSON(_ data: Data) -> [String: Any]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        guard let dict = json as? [String: Any] else { return nil }
        return dict
    }
}
