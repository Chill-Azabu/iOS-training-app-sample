//
//  ViewController.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit

// ViewControllerで共通して使用する処理をまとめる
protocol ViewController {
    func showAlertDialog(title: String, message: String)
}

extension ViewController where Self: UIViewController {
    func showAlertDialog(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: true)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: true)
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        // ④ Alertを表示
        self.present(alert, animated: true)
    }
}
