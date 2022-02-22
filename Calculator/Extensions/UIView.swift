//
//  UIView.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

extension UIView {
    
    func addConstraints(top: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                        bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                        leading: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                        trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: [ self.topAnchor.constraint(equalTo: top),
                                         self.bottomAnchor.constraint(equalTo: bottom),
                                         self.trailingAnchor.constraint(equalTo: trailing),
                                         self.leadingAnchor.constraint(equalTo: leading)
        ])
        return constraints
    }
    
    func addConstraints(top: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                        trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                        trailingConstant: CGFloat,
                        height: CGFloat,
                        width: CGFloat) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: [ self.topAnchor.constraint(equalTo: top),
                                         self.trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant),
                                         self.heightAnchor.constraint(equalToConstant: height),
                                         self.widthAnchor.constraint(equalToConstant: width)])
        return constraints
    }
    
    func addConstraints(bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                        trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                        leading: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                        trailingConstant: CGFloat,
                        leadingConstant: CGFloat,
                        height: CGFloat) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: [ self.bottomAnchor.constraint(equalTo: bottom),
                                         self.trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant),
                                         self.leadingAnchor.constraint(equalTo: leading, constant: leadingConstant),
                                         self.heightAnchor.constraint(equalToConstant: height)])
        return constraints
    }
    
    func addConstraints(top: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                        leading: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                        trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                        height: NSLayoutDimension,
                        multiplier: CGFloat) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: [ self.topAnchor.constraint(equalTo: top),
                                         self.trailingAnchor.constraint(equalTo: trailing),
                                         self.leadingAnchor.constraint(equalTo: leading),
                                         self.heightAnchor.constraint(equalTo: height, multiplier: multiplier)
        ])
        return constraints
    }
}

