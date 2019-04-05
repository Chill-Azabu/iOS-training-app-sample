//
//  ContentsDataSource.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/13.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation
import UIKit

class ContentsDataSource: NSObject {
    typealias Content = [ContentsListEntity]

    var items: Content

    init(items: Content) {
        self.items = items
    }
}

extension ContentsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        cell.setViewData(data: items[indexPath.row])
        return cell
    }
}
