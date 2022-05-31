//
//  HistoryControllerViewController.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

class HistoryController: UIViewController {
    var historyView = HistoryView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = historyView
        historyView.setupView()
        historyView.addConstraints()
        NSLayoutConstraint.activate(historyView.sharedConstraints)
        historyView.tableView.delegate = self
        historyView.tableView.dataSource = self
        historyView.tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseID)
        historyView.tableView.rowHeight = UITableView.automaticDimension
        historyView.tableView.estimatedRowHeight = 44
        historyView.tableView.separatorColor = .white
    }
    
}
    //Реализация методов UITableViewDelegate и UITableViewDataSource
extension HistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyView.historyItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseID) as! HistoryCell
        cell.itemLabel.text = historyView.historyItem[indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
}
