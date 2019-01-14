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
        }
    }

    @IBOutlet weak var contentsPriceLabel: UILabel! {
        didSet {
            contentsNameLabel.text = "金額"
            contentsNameLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var contentsPriceTextField: UITextField! {
        didSet {
            contentsPriceTextField.placeholder = "テキスト入力"
        }
    }

    @IBOutlet weak var purchaseDateLabel: UILabel! {
        didSet {
            contentsNameLabel.text = "購入日"
            contentsNameLabel.textAlignment = .left
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
    
    private let disposeBag: DisposeBag = .init()
    private lazy var viewModel = ContentsAddViewModelImpl(
        input: (
            image: contentsImageView.image!,
            title: contentsNameTextField.rx.text.orEmpty.asDriver(),
            price: contentsPriceTextField.rx.text.orEmpty.asDriver(),
            purchaseDate: purchaseDateTextField.rx.text.orEmpty.asDriver(),
            saveButtonTap: saveButton.rx.tap.asSignal()
        )
        ,dependency: ContentsRepositoryImpl())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Palette.yellow
        setupNavBar()
        bindUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func bindUI() {
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)

        contentsPickerButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let imagePic = UIImagePickerController()
                imagePic.delegate = self
                imagePic.sourceType = .photoLibrary
                imagePic.allowsEditing = true
                self.present(imagePic, animated: true)
            }).disposed(by: disposeBag)

        purchaseDateTextField.rx.controlEvent(.allTouchEvents)
            .subscribe(onNext: { [unowned self] _ in
                self.purchaseDateTextField.inputView = self.datePicker
            }).disposed(by: disposeBag)

        datePicker.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                self.purchaseDateTextField.text = formatter.string(from: self.datePicker.date)
            }).disposed(by: disposeBag)

        viewModel.responseError.skip(1)
            .subscribe(onNext: { [unowned self] _ in
                self.showAlertDialog(title: "レスポンスエラー", message: "データの追加に失敗しました")
            }).disposed(by: disposeBag)

    }

    private func setupNavBar() {
        title = "書籍追加"
        navigationItem.setRightBarButton(saveButton, animated: true)
        navigationItem.setLeftBarButton(closeButton, animated: true)
    }
}

extension ContentsAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension ContentsAddViewController {
    static func createInstance() -> ContentsAddViewController {
        let instance = R.storyboard.contentsAddViewController.contentsAddViewController()!
        return instance
    }
}
