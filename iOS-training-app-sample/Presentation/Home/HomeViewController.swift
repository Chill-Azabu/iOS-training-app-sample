//
//  HomeViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
            tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }

    @IBOutlet weak var loadButton: UIButton! {
        didSet {
            loadButton.setTitle("読み込む", for: .normal)
        }
    }

    private var dataSource = ContentsDataSource(items: [])

    private var viewModel: HomeViewModel!
    private var routing: HomeRouting! {
        didSet {
            routing.viewController = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Palette.gray
        navigationController?.navigationBar.barTintColor = Color.Palette.lightGray
        setupNavBar()
    }

    private func setupNavBar() {
        title = "書籍一覧"
        let addButton = UIBarButtonItem(title: "追加", style: .plain, target: self, action: nil)
        tabBarController?.navigationItem.setRightBarButton(addButton, animated: true)

        addButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showContentAdd()
            }).disposed(by: viewModel.disposeBag)

        // indexpathをVCに渡して遷移する
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.routing.showContentsEdit(indexPath: indexPath.row)
            }).disposed(by: viewModel.disposeBag)

        loadButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }).disposed(by: viewModel.disposeBag)

//        viewModel.contentsList
//            .subscribe(onNext: { [unowned self] results in
//                self.dataSource.items = results
//                self.tableView.reloadData()
//            }).disposed(by: viewModel.disposeBag)
        }
}

extension HomeViewController {
    static func createInstance() -> HomeViewController {
        let instance = R.storyboard.homeViewController.homeViewController()!
        instance.viewModel = HomeViewModelImpl(
            input: instance.rx.viewWillAppear,
            dependency: ContentsRepositoryImpl()
        )
        instance.routing = HomeRoutingImpl()
        return instance
    }
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        return sentMessage(#selector(base.viewWillAppear(_:)))
            .map { _ in () }
            .share(replay: 1)
    }
}
