//
//  ContentsAddRouting.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/06.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit

protocol ContentsAddRouting: Routing {
    func showHome()
}

final class ContentsAddRoutingImpl: ContentsAddRouting {

    weak var viewController: UIViewController?

    func showHome() {
        viewController?.dismiss(animated: false)
    }
}
