//
//  ContentsEditViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/22.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxSwift

class ContentsEditViewController: UIViewController, ViewController {

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
            contentsNameTextField.placeholder = "テキスト入力"
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

    private let closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: nil)
        return closeButton
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    private var viewModel: ContentsEditViewModel!
    private var routing: ContentsEditRouting! {
        didSet {
            routing.viewController = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Palette.gray
        navigationController?.navigationBar.barTintColor = Color.Palette.lightGray

        self.bindView()
//        viewModel.imageView.asObservable()
//            .bind(to: contentsImageView.rx.image)
//            .disposed(by: viewModel.disposeBag)
    }

    private func bindView() {
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showHome()
            }).disposed(by: viewModel.disposeBag)

        contentsPickerButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let imagePic = UIImagePickerController()
                imagePic.delegate = self
                imagePic.sourceType = .photoLibrary
                imagePic.allowsEditing = true
                self.present(imagePic, animated: true)
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
                self.showAlertDialog(title: "レスポンスエラー", message: "データの編集に失敗しました")
            }).disposed(by: viewModel.disposeBag)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func setupNavBar() {
        title = "書籍編集"
        navigationItem.setRightBarButton(saveButton, animated: true)
        navigationItem.setLeftBarButton(closeButton, animated: true)
    }
}

extension ContentsEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){

        if let pickedImage = info[.originalImage]
            as? UIImage {
            contentsImageView.image = pickedImage
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ContentsEditViewController {
    static func createInstance(indexPath: Int) -> ContentsEditViewController {
        let instance = R.storyboard.contentsEditViewController.contentsEditViewController()!
        instance.viewModel = ContentsEditViewModelImpl(
            input: (
                title: instance.contentsNameTextField.rx.text.orEmpty.asDriver(),
                price: instance.contentsPriceTextField.rx.text.orEmpty.asDriver(),
                purchaseDate: instance.purchaseDateTextField.rx.text.orEmpty.asDriver(),
                saveButtonTap: instance.saveButton.rx.tap.asSignal()
            ),dependency: ContentsRepositoryImpl(), indexPath: indexPath)
        instance.routing = ContentsEditRoutingImpl()
        return instance
    }
}
