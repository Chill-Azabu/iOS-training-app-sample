//
//  HomeViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {

    typealias DataSource = HomeContentsDataSource<HomeTableViewCell, HomeTableViewCell.ViewData>

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
            tableView.register(UINib(nibName: HomeTableViewCell.className, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.className)
        }
    }

    private lazy var dataSource: DataSource = {
        return HomeContentsDataSource(
        cellReuseIdentifier: HomeTableViewCell.className) { cell, item, _ in
            cell.viewData = item
        }
    }()

    @IBOutlet weak var loadButton: UIButton! {
        didSet {
            loadButton.setTitle("読み込む", for: .normal)
        }
    }

    private lazy var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(title: "追加", style: .plain, target: self, action: nil)
        navigationItem.setRightBarButton(addButton, animated: true)
        return addButton
    }()

    private var viewModel: HomeViewModel!
    private var routing: HomeRouting! {
        didSet {
            routing.viewController = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "書籍一覧"
        view.backgroundColor = AppResource.Color.snowWhite
        navigationController?.navigationBar.barTintColor = AppResource.Color.lightGray
        bindUI()
    }

    private func bindUI() {
        addButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showContentAdd()
            }).disposed(by: viewModel.disposeBag)

        // indexpathをVCに渡して遷移する
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.routing.showContentsEdit(indexPath: Int(indexPath.row))
            }).disposed(by: viewModel.disposeBag)

        loadButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }).disposed(by: viewModel.disposeBag)

        viewModel.contentsList
            .subscribe(onNext: { [unowned self] results in
                self.dataSource.set(listItems: results)
                self.tableView.reloadData()
            }).disposed(by: viewModel.disposeBag)
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
