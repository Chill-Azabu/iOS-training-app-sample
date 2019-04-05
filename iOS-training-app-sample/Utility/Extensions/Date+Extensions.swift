//
//  Date+Extensions.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/13.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation

extension Date {
    func stringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }

    func dateFromString(string: String) -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }

}
