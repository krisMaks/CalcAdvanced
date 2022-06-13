//
//  UIButton+Extensions.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

extension UIButton {
    
    func addStyleMainButton() {
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont(name: "Menlo", size: 30)
        self.setTitleColor(.white, for: .normal)
    }
    
    func addStyleHistoryButton() {
        self.titleLabel?.font = UIFont(name: "Menlo", size: 15)
        self.titleLabel?.textAlignment = .center
        self.setTitle("history", for: .normal)
        self.backgroundColor = UIColor(named: "darkGrayButton")
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
