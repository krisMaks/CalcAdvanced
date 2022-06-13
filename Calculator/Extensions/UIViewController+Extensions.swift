//
//  UIViewController+Extensions.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

extension MainViewController {
    
    func alertEmptyHistory() {
        let alertController = UIAlertController(title: nil, message: "История отсутствует", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(actionAlert)
        present(alertController, animated: true, completion: nil)
    }
    
    func divisionByZero() {
        let alertController = UIAlertController(title: nil, message: "Делить на ноль ЗАПРЕЩЕНО!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
