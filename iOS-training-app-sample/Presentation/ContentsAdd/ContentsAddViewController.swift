//
//  ContentsAddViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxSwift

class ContentsAddViewController: UIViewController, ViewController {

    @IBOutlet weak var contentsImageView: UIImageView! {
        didSet {
            contentsImageView.contentMode = .scaleAspectFit
        }
    }

    @IBOutlet weak var contentsPickerButton: UIButton! {
        didSet {
            contentsPickerButton.setTitle("画像選択ボタン", for: .normal)
        }
    }

    @IBOutlet weak var contentsNameLabel: UILabel! {
        didSet {
            contentsNameLabel.text = "書籍名"
            contentsNameLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var contentsNameTextField: UITextField! {
        didSet {
            contentsNameTextField.placeholder = "テキスト入力"
            contentsNameTextField.clearButtonMode = .whileEditing
        }
    }

    @IBOutlet weak var contentsPriceLabel: UILabel! {
        didSet {
            contentsPriceLabel.text = "金額"
            contentsPriceLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var contentsPriceTextField: UITextField! {
        didSet {
            contentsPriceTextField.placeholder = "テキスト入力"
            contentsPriceTextField.clearButtonMode = .whileEditing
        }
    }

    @IBOutlet weak var purchaseDateLabel: UILabel! {
        didSet {
            purchaseDateLabel.text = "購入日"
            purchaseDateLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var purchaseDateTextField: UITextField!

    private let saveButton: UIBarButtonItem = {
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: nil)
        return saveButton
    }()

    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: nil)
        return closeButton
    }()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    private lazy var viewModel: ContentsAddViewModel = {
        let viewModel = ContentsAddViewModelImpl(
            input: (
                title: contentsNameTextField.rx.text.orEmpty.asDriver(),
                price: contentsPriceTextField.rx.text.orEmpty.asDriver(),
                purchaseDate: purchaseDateTextField.rx.text.orEmpty.asDriver(),
                saveButtonTap: saveButton.rx.tap.asSignal()
            ),dependency: ContentsRepositoryImpl())
        return viewModel
    }()

    private var routing: ContentsAddRouting! {
        didSet {
            routing.viewController = self
        }
    }

    private lazy var imagePic: UIImagePickerController = {
        let imagePic = UIImagePickerController()
        imagePic.sourceType = .photoLibrary
        imagePic.allowsEditing = true
        return imagePic
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Palette.gray
        navigationController?.navigationBar.barTintColor = Color.Palette.lightGray
        setupNavBar()
        bindUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func bindUI() {
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showHome()
            }).disposed(by: viewModel.disposeBag)

        contentsPickerButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.imagePic.present(self.imagePic, animated: true)
            }).disposed(by: viewModel.disposeBag)

        purchaseDateTextField.rx.controlEvent(.allTouchEvents)
            .subscribe(onNext: { [unowned self] _ in
                self.purchaseDateTextField.inputView = self.datePicker
            }).disposed(by: viewModel.disposeBag)

        datePicker.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                self.purchaseDateTextField.text = formatter.string(from: self.datePicker.date)
            }).disposed(by: viewModel.disposeBag)

        viewModel.responseError.skip(1)
            .subscribe(onNext: { [unowned self] _ in
                self.showAlertDialog(title: "レスポンスエラー", message: "データの追加に失敗しました")
            }).disposed(by: viewModel.disposeBag)

        viewModel.imageView
            .drive(onNext: { [unowned self] image in
                self.contentsImageView.image = image
            }).disposed(by: viewModel.disposeBag)

        imagePic.rx.didFinishPickingMediaWithInfo
            .subscribe(onNext: { [weak self] photoImage in
                if let pickedImage = photoImage[.originalImage] as? UIImage {
                    self?.contentsImageView.image = pickedImage
                }
                self?.imagePic.dismiss(animated: true)
            }).disposed(by: viewModel.disposeBag)

        imagePic.rx.didCancel
            .subscribe(onNext: { [unowned self] _ in
                self.imagePic.dismiss(animated: true)
            }).disposed(by: viewModel.disposeBag)

    }

    private func setupNavBar() {
        title = "書籍追加"
        navigationItem.setRightBarButton(saveButton, animated: true)
        navigationItem.setLeftBarButton(closeButton, animated: true)
    }
}

extension ContentsAddViewController {
    static func createInstance() -> ContentsAddViewController {
        let instance = R.storyboard.contentsAddViewController.contentsAddViewController()!
        instance.routing = ContentsAddRoutingImpl()
        return instance
    }
}
