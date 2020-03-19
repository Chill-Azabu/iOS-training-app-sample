//
//  HomeRouting.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/04/06.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit

protocol HomeRouting: Routing {
    func showContentAdd()
    func showContentsEdit(indexPath: Int)
}

final class HomeRoutingImpl: HomeRouting {

    weak var viewController: UIViewController?

    func showContentAdd() {
        let vc = ContentsAddViewController.createInstance()
        let nc = UINavigationController(rootViewController: vc)
        viewController?.present(nc, animated: true)
    }

    func showContentsEdit(indexPath: Int) {
        let vc = ContentsEditViewController.createInstance(indexPath: indexPath)
        viewController?.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
}
