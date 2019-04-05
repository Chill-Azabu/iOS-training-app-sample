//
//  ContentsEditRouting.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/06.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit

protocol ContentsEditRouting: Routing {
    func showHome()
}

final class ContentsEditRoutingImpl: ContentsEditRouting {

    weak var viewController: UIViewController?

    func showHome() {
        viewController?.dismiss(animated: false)
    }
}
