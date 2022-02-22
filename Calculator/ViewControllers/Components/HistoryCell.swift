//
//  HistoryCell.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let reuseID = "HistoryCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Menlo", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        self.contentView.addSubview(itemLabel)
        self.backgroundColor = .clear
        addConstraints()
    }
    
    func addConstraints() {
        itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

