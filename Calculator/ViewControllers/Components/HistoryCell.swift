//
//  HistoryCell.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

class HistoryCell: UITableViewCell {
    //Создание необходимых UI-элементов, констант и переменных
    static let reuseID = "HistoryCell"
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Menlo", size: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(itemLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        addConstraints()
    }
    //Установка констрейнтов для элементов
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints = itemLabel.addConstraints(top: topAnchor, topConstant: 10, bottom: bottomAnchor, bottomConstant: -10, trailing: trailingAnchor, leading: leadingAnchor, trailingConstant: -20, leadingConstant: 20)
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

