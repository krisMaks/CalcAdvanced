//
//  HistoryControllerViewController.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

class HistoryController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .black
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
    var sharedConstraints = [NSLayoutConstraint]()
    var historyItem = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        addConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseID)
    }
    
    func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                                     titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        sharedConstraints = tableView.addConstraints(top: titleLabel.bottomAnchor,
                                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                                     leading: view.safeAreaLayoutGuide.leadingAnchor,
                                                     trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
    }
}


extension HistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseID) as! HistoryCell
        cell.itemLabel.text = historyItem[indexPath.row]
        return cell
    }
}
