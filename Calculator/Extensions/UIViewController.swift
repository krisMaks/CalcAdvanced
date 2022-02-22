//
//  UIViewController.swift
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
}
