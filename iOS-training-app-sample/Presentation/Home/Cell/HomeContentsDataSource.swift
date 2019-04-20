//
//  ContentsDataSource.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/13.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation
import UIKit

class HomeContentsDataSource<CellType, EntityType>: NSObject, UITableViewDataSource {

    private let cellReuseIdentifier: String
    private let cellConfigurationHandler: (CellType, EntityType, IndexPath) -> Void

    private var listItems = [EntityType]()

    init(cellReuseIdentifier: String,
         cellConfigurationHandler: @escaping (CellType, EntityType, IndexPath) -> Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurationHandler = cellConfigurationHandler
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        guard !listItems.isEmpty else { return cell }
        let item = listItems[indexPath.row]

        if let cell = cell as? CellType {
            cellConfigurationHandler(cell, item, indexPath)
        }

        return cell
    }
}

extension HomeContentsDataSource {
    func set(listItems: [EntityType]) {
        self.listItems = listItems
    }

    func getItem(index: Int) -> EntityType {
        return self.listItems[index]
    }
}
