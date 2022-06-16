//
//  HistoryView.swift
//  CalcAdvanced
//
//  Created by Кристина Максимова on 31.05.2022.
//

import UIKit

class HistoryView: UIView {
    //Создание необходимых UI-элементов, констант и переменных
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(named: "lightBlack")
        table.allowsSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "История операций"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private(set) var sharedConstraints = [NSLayoutConstraint]()
    var historyItem = [String]()
    
    //Добавление subview на view
    func setupView() {
        self.backgroundColor = UIColor(named: "lightBlack")
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        self.addSubview(titleLabel)
        self.addSubview(tableView)
    }
    //Установка констрейнтов для элементов
    func addConstraints() {
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
                                     titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        sharedConstraints = tableView.addConstraints(top: titleLabel.bottomAnchor,
                                                     topConstant: 20,
                                                     bottom: self.safeAreaLayoutGuide.bottomAnchor,
                                                     leading: self.safeAreaLayoutGuide.leadingAnchor,
                                                     trailing: self.safeAreaLayoutGuide.trailingAnchor)
        
    }
}
