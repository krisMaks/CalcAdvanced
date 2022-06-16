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
    private var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 14
        return nf
    }
    private var currentInput: Double {
        get {
            return Double(mainView.resultLabel.text ?? "0") ?? 0
        }
        set {
            if newValue.isNaN {
                mainView.resultLabel.text = "Не определено"
            } else {
                let value = "\(newValue)"
                let valueArray = value.components(separatedBy: ".")
                if valueArray[1] == "0" {
                    mainView.resultLabel.text = "\(valueArray[0])"
                } else {
                    mainView.resultLabel.text = numberFormatter.string(from: newValue as NSNumber)
                }
                model.stillTyping = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.setConstraints()
    }

    
    //MARK: - Change layout
    //Метод для получения текущего размера экрана, используется в traitCollectionDidChange()
    private func layoutTrait(traitCollection: UITraitCollection) {
        NSLayoutConstraint.activate(mainView.sharedConstraints)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            mainView.setView(with: mainView.namesSharedButton)
            addActions()
        } else {
            mainView.setView(with: mainView.namesRegularButton)
            addActions()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    //MARK: - Targets
    //Target для кнопок
    func addActions() {
        mainView.historyButton.addTarget(self, action: #selector(getHistory), for: .touchUpInside)
        for lines in mainView.buttons {
            for button in lines {
                if button.textValue.containsOnly(.nums) {
                    button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
                }
                if button.textValue.containsOnly(.binaryOperations) {
                    button.addTarget(self, action: #selector(binaryOperatorPressed), for: .touchUpInside)
                }
                if button.textValue.containsOnly(.equal) {
                    button.addTarget(self, action: #selector(equalPressed), for: .touchUpInside)
                }
                if button.textValue.containsOnly(.dot) {
                    button.addTarget(self, action: #selector(dotPressed), for: .touchUpInside)
                }
                if button.textValue.containsOnly(.unaryOperations) {
                    button.addTarget(self, action: #selector(unaryOperatorPressed), for: .touchUpInside)
                }
                if button.textValue.containsOnly(.other) {
                    button.addTarget(self, action: #selector(otherOperatorPressed), for: .touchUpInside)
                }
                if button.textValue.containsOnly(.percent) {
                    button.addTarget(self, action: #selector(persentPressed), for: .touchUpInside)
                }
                if button.textValue.containsOnly(.memory) {
                    button.addTarget(self, action: #selector(memoryOperatorPressed), for: .touchUpInside)
                }
                if button.textValue.containsOnly(.bracket) {
                    button.addTarget(self, action: #selector(bracketPressed), for: .touchUpInside)
                }
            }
        }
    }
    
    
    //MARK: - @objc
    
    @objc func numberPressed(_ sender: UIButton) {
        guard let number = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        guard let result = model.numberInput(number, currentResult) else { return }
        mainView.resultLabel.text = result
        
    }
    
    @objc func binaryOperatorPressed(_ sender: UIButton) {
        guard let binaryOperator = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        guard let result = model.binaryOperatorInput(binaryOperator, currentResult, currentInput) else { return }
        mainView.resultLabel.text = result
    }
    
    @objc func unaryOperatorPressed(_ sender: UIButton) {
        guard let unaryOperator = sender.currentTitle else { return }
        guard let result = model.unaryOperatorInput(unaryOperator, currentInput) else { return }
        currentInput = result
    }
    
    @objc func equalPressed(_ sender: UIButton) {
        guard let currentResult = mainView.resultLabel.text else { return }
        guard let result = model.equalOperation(currentResult, currentInput) else {
            currentInput = 0
            self.divisionByZero()
            return }
        currentInput = result
        writeHistory()
    }
    
    @objc func memoryOperatorPressed(_ sender: UIButton) {
        guard let memoryOperator = sender.currentTitle else { return }
        guard let result = model.memoryOperatorInput(memoryOperator, currentInput) else { return }
        currentInput = result
    }
    
    @objc func persentPressed() {
        guard let result = model.persentInput(currentInput) else { return }
        currentInput = result
    }
    
    @objc func dotPressed() {
        guard let currentResult = mainView.resultLabel.text else { return }
        guard let result = model.dotInput(currentResult) else { return }
        mainView.resultLabel.text = result
    }
    
    @objc func otherOperatorPressed(_ sender: UIButton) {
        guard let otherOperator = sender.currentTitle else { return }
        guard let result = model.otherOperatorInput(otherOperator, currentInput) else { return }
        currentInput = result
    }
    
    @objc func bracketPressed(_ sender: UIButton) {
        guard let bracket = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        mainView.resultLabel.text = model.bracketInput(bracket, currentResult)
    }
    
    @objc func getHistory() {
        let vc = HistoryViewController()
        if let history = UserSettings.historyArray {
            vc.historyView.historyItem = history
            if #available(iOS 15.0, *) {
                vc.sheetPresentationController?.prefersGrabberVisible = true
            }
            present(vc, animated: true, completion: nil)
        } else {
            self.alertEmptyHistory()
        }
    }
    
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
            if !self.model.operationSymbol.containsOnly(.binaryOperations) {
                UserSettings.historyArray.insert("\(self.model.firstOperand) \(self.model.operationSymbol) \(self.model.secondOperand)", at: 0)
            }
        }
    }
}

