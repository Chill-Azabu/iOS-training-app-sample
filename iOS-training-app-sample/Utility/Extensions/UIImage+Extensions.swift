//
//  UIImage+Extensions.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2019/01/07.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    final func applyImage(with url: URL) {
        self.kf.setImage(with: url) { [weak self] image, error, _, _ in
            if let _ = error, let image = image {
                self?.image = image
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}
