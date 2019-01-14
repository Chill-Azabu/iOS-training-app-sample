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

    private let disposeBag: DisposeBag = .init()
    private var dataSource = ContentsDataSource(items: [])

    private lazy var viewModel = HomeViewModelImpl(
        input: rx.viewWillAppear,
        dependency: ContentsRepositoryImpl()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Palette.yellow
        setupNavBar()
    }

    private func setupNavBar() {
        title = "書籍一覧"
        let addButton = UIBarButtonItem(title: "追加", style: .plain, target: self, action: nil)
        tabBarController?.navigationItem.setRightBarButton(addButton, animated: true)

        addButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let nc = UINavigationController(rootViewController: ContentsAddViewController.createInstance())
                self.present(nc, animated: true)
            }).disposed(by: disposeBag)

        // indexpathをVCに渡して遷移する
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                let vc = ContentsEditViewController.createInstance(indexPath: indexPath.row)
                self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)

        loadButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)

        viewModel.contentsList
            .subscribe(onNext: { [unowned self] results in
                self.dataSource.items = results
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        }
}

extension HomeViewController {
    static func createInstance() -> HomeViewController {
        let instance = R.storyboard.homeViewController.homeViewController()!
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
