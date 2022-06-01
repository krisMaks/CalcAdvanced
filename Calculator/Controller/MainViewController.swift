//
//  ViewController.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    
    
    private var mainView = MainView()
    private var model = CalculateModel()
    private var currentInput: Double {
        get {
            return Double(mainView.resultLabel.text ?? "0") ?? 0
        }
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                mainView.resultLabel.text = "\(valueArray[0])"
            } else {
                mainView.resultLabel.text = "\(newValue)"
            }
            model.stillTyping = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.setupView()
        mainView.setConstraints()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
        mainView.historyButton.addTarget(self, action: #selector(getHistory), for: .touchUpInside)
    }
    
    
    
    
    //MARK: - Change layout
    //Метод для получения текущего размера экрана, используется в traitCollectionDidChange()
    private func layoutTrait(traitCollection: UITraitCollection) {
        NSLayoutConstraint.activate(mainView.sharedConstraints)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            mainView.setView(with: mainView.namesSharedButton)
            addActions()
//        } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
//            setView(with: namesRegularButton)
        } else {
            mainView.setView(with: mainView.namesRegularButton)
            addActions()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    func addActions() {
        for lines in mainView.buttons {
            for button in lines {
                if !(button.currentTitle?.containsOtherThan(.nums))! {
                    button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
                }
                if !(button.currentTitle?.containsOtherThan(.binaryOperations))! {
                    button.addTarget(self, action: #selector(binaryOperatorPressed), for: .touchUpInside)
                }
                if !(button.currentTitle?.containsOtherThan(.equal))! {
                    button.addTarget(self, action: #selector(equalPressed), for: .touchUpInside)
                }
                if !(button.currentTitle?.containsOtherThan(.dot))! {
                    button.addTarget(self, action: #selector(dotOperatorPressed), for: .touchUpInside)
                }
                if !(button.currentTitle?.containsOtherThan(.unaryOperations))! {
                    button.addTarget(self, action: #selector(unaryOperatorPressed), for: .touchUpInside)
                }
                if !(button.currentTitle?.containsOtherThan(.other))! {
                    button.addTarget(self, action: #selector(otherOperatorPressed), for: .touchUpInside)
                }
                if !(button.currentTitle?.containsOtherThan(.percent))! {
                    button.addTarget(self, action: #selector(persentOperatorPressed), for: .touchUpInside)
                }
                if !(button.currentTitle?.containsOtherThan(.memory))! {
                    button.addTarget(self, action: #selector(memoryOperatorPressed), for: .touchUpInside)
                }
                if !(button.currentTitle?.containsOtherThan(.bracket))! {
                    button.addTarget(self, action: #selector(bracketPressed), for: .touchUpInside)
                }
            }
        }
    }
    
    
    //MARK: - Targets
    //Target для кнопок
    @objc func numberPressed(_ sender: UIButton) {
        guard let number = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        guard let result = model.numberPressed(number, currentResult) else { return }
        mainView.resultLabel.text = result
        
    }
    
    @objc func binaryOperatorPressed(_ sender: UIButton) {
        guard let binaryOperator = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        guard let result = model.binaryOperatorPressed(binaryOperator, currentResult, currentInput) else { return }
        mainView.resultLabel.text = result
    }
    
    @objc func unaryOperatorPressed(_ sender: UIButton) {
        guard let unaryOperator = sender.currentTitle else { return }
        guard let result = model.unaryOperatorPressed(unaryOperator, currentInput) else { return }
        currentInput = result
    }
    
    @objc func equalPressed(_ sender: UIButton) {
        guard let currentResult = mainView.resultLabel.text else { return }
        guard let result = model.equalPressed(currentResult, currentInput) else { return }
        currentInput = result
        writeHistory()
    }
    
    @objc func memoryOperatorPressed(_ sender: UIButton) {
        guard let memoryOperator = sender.currentTitle else { return }
        guard let result = model.memoryOperatorPressed(memoryOperator, currentInput) else { return }
        currentInput = result
    }
    
    @objc func persentOperatorPressed() {
        guard let result = model.persentOperatorPressed(currentInput) else { return }
        currentInput = result
    }
    
    @objc func dotOperatorPressed() {
        guard let currentResult = mainView.resultLabel.text else { return }
        guard let result = model.dotOperatorPressed(currentResult) else { return }
        mainView.resultLabel.text = result
    }
    
    @objc func otherOperatorPressed(_ sender: UIButton) {
        guard let otherOperator = sender.currentTitle else { return }
        guard let result = model.otherOperatorPressed(otherOperator, currentInput) else { return }
        currentInput = result
    }
    
    @objc func bracketPressed(_ sender: UIButton) {
        guard let bracket = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        mainView.resultLabel.text = model.bracketPressed(bracket, currentResult)
    }
    
    @objc func getHistory() {
        let vc = HistoryViewController()
        if let history = UserSettings.historyArray {
            vc.historyView.historyItem = history
            present(vc, animated: true, completion: nil)
        } else {
            self.alertEmptyHistory()
        }
    }
    
    //MARK: - Expression
    //Методы для подсчета результата
    
    
    
    
    //MARK: - History
    //Метод для записи операций в историю
    private func writeHistory() {
        DispatchQueue.global(qos: .utility).async {
            if UserSettings.historyArray == nil {
                UserSettings.historyArray = []
            }
            if UserSettings.historyArray.count > 19 {
                UserSettings.historyArray = []
            }
            if !self.model.operationSymbol.containsOtherThan(.binaryOperations) {
                UserSettings.historyArray.insert("\(self.model.firstOperand) \(self.model.operationSymbol) \(self.model.secondOperand)", at: 0)
            }
        }
    }
}

