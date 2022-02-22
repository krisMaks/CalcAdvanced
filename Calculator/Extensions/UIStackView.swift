//
//  UIStackView.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

extension UIStackView {
    convenience init(views: [UIView],
                     axis: NSLayoutConstraint.Axis) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.distribution = .fillEqually
    }
    
    func setConfig(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
        self.spacing = 1
        self.distribution = .fillEqually
    }
}
