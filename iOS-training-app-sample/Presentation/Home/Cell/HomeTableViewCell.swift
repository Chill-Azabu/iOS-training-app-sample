//
//  HomeTableViewCell.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    struct ViewData {
        let name: String
        let price: Int
        let image: String
        let purchaseDate: String
    }

    private let titleLabel: UILabel = {
        let titlelabel = UILabel()
        titlelabel.text = "書籍名"
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        return titlelabel
    }()

    private let valueLabel: UILabel = {
        let value = UILabel()
        value.text = "価格"
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private let dateLabel: UILabel = {
        let date = UILabel()
        date.text = "購入日"
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()

    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 35, y: 0, width: 80, height: 100)
        return imageView
    }()

    var viewData: ViewData! {
        didSet {
            titleLabel.text = viewData.name
            valueLabel.text = String(viewData.price) + "税"
            dateLabel.text = viewData.purchaseDate.replacingOccurrences(of: "-", with: "/")
            bookImageView.kf.indicatorType = .activity
            bookImageView.applyImage(with: URL(string: viewData.image)!)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setupLayout()
    }

    private func addSubviews(){
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(dateLabel)
        addSubview(bookImageView)
    }

    private func setupLayout() {
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: -30).isActive  = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 170).isActive = true

        valueLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 100).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true

        dateLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor, constant: 0).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: 85).isActive = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError()
    }
}
