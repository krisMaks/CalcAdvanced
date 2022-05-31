//
//  ViewController.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    
    private var firstOperand: Double = 0
    private var secondOperand: Double = 0
    private var memory: [Double] = [0]
    private var operationSymbol: String = ""
    private var isDot = false
    private var stillTyping = false
    private var isBrakets = false
    private var mainView = MainView()
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
            stillTyping = false
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
    
    //MARK: - Setings view
   
    //Создание кнопок для различных размеров экрана и добавление target для них
    
    //Размещение кнопок в горизонтальных stackView
    
    
    //MARK: - Change layout
    //Метод для получения текущего размера экрана, используется в traitCollectionDidChange()
    private func layoutTrait(traitCollection: UITraitCollection) {
        NSLayoutConstraint.activate(mainView.sharedConstraints)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            mainView.setView(with: mainView.namesSharedButton)
//        } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
//            setView(with: namesRegularButton)
        } else {
            mainView.setView(with: mainView.namesRegularButton)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    
    //MARK: - Targets
    //Target для кнопок
    @objc func numberPressed(_ sender: UIButton) {
        guard let number = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        if stillTyping {
            if currentResult.count < 12 {
                mainView.resultLabel.text = currentResult + number
            }
        } else if isBrakets {
            stillTyping = true
            mainView.resultLabel.text = currentResult + number
        } else {
            mainView.resultLabel.text = number
            stillTyping = true
        }
    }
    
    @objc func binaryOperatorPressed(_ sender: UIButton) {
        guard let binaryOperator = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        if isBrakets {
            mainView.resultLabel.text = currentResult + binaryOperator
        } else {
            operationSymbol = binaryOperator
            firstOperand = currentInput
            stillTyping = false
            isDot = false
        }
    }
    
    @objc func unaryOperatorPressed(_ sender: UIButton) {
        guard let unaryOperator = sender.currentTitle else { return }
        operationSymbol = unaryOperator
        stillTyping = false
        isDot = false
        switch operationSymbol {
        case "x²":
            unaryOperation { pow($0, 2) }
        case "x³":
            unaryOperation { pow($0, 3) }
        case "√":
            unaryOperation { sqrt($0) }
        case "sin":
            unaryOperation { sin($0) }
        case "cos":
            unaryOperation { cos($0) }
        case "tan":
            unaryOperation { tan($0) }
        case "∛":
            unaryOperation { cbrt($0) }
        case "±":
            if currentInput != 0 {
                currentInput *= -1
            }
        default: break
        }
        if firstOperand != 0 {
            secondOperand = currentInput
        } else {
            firstOperand = currentInput
        }
    }
    
    @objc func equalPressed(_ sender: UIButton) {
        guard let currentResult = mainView.resultLabel.text else { return }
        if stillTyping && !isBrakets {
            secondOperand = currentInput
        }
        if isBrakets {
            stillTyping = false
            if currentResult.numberBrackets() {
                bracketOperation(with: currentResult)
            } else {
                currentInput = 0
                isBrakets = false
            }
        }
        switch operationSymbol {
        case "+":
            binaryOperation { $0 + $1 }
        case "-":
            binaryOperation { $0 - $1 }
        case "÷":
            if secondOperand != 0 {
                binaryOperation { $0 / $1 }
            } else {
                currentInput = 0
            }
        case "×":
            binaryOperation { $0 * $1 }
        case "xª":
            binaryOperation { pow($0, $1) }
        default:
            binaryOperation { $0 + $1 }
        }
        isBrakets = false
        isDot = false
        writeHistory()
    }
    
    @objc func memoryOperatorPressed(_ sender: UIButton) {
        guard let memoryOperator = sender.currentTitle else { return }
        operationSymbol = memoryOperator
        stillTyping = false
        switch operationSymbol {
        case "MC":
            memory = [0]
        case "M＋":
            memory.append(currentInput + memory.last!)
        case "M౼":
            memory.append(currentInput - memory.last!)
        case "MR":
            currentInput = memory.last!
        default: break
        }
    }
    
    @objc func persentOperatorPressed(_ sender: UIButton) {
        if firstOperand == 0 {
            currentInput /= 100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
        stillTyping = false
    }
    
    @objc func dotOperatorPressed(_ sender: UIButton) {
        guard let currentResult = mainView.resultLabel.text else { return }
        if stillTyping && !isDot {
            mainView.resultLabel.text = currentResult + "."
        } else if !stillTyping && !isDot {
            mainView.resultLabel.text = "0."
            stillTyping = true
        }
        isDot = true
    }
    
    @objc func otherOperatorPressed(_ sender: UIButton) {
        guard let otherOperator = sender.currentTitle else { return }
        operationSymbol = otherOperator
        stillTyping = false
        
        switch operationSymbol {
        case "π":
            currentInput = Double.pi
            if firstOperand != 0 {
                secondOperand = currentInput
            } else {
                firstOperand = currentInput
            }
        case "AC":
            firstOperand = 0
            secondOperand = 0
            currentInput = 0
            operationSymbol = ""
            stillTyping = false
            isDot = false
            isBrakets = false
        case "e":
            currentInput = exp(1)
            if firstOperand != 0 {
                secondOperand = currentInput
            } else {
                firstOperand = currentInput
            }
        default: break
        }
    }
    
    @objc func bracketPressed(_ sender: UIButton) {
        guard let bracket = sender.currentTitle, let currentResult = mainView.resultLabel.text else { return }
        isBrakets = true
        if stillTyping {
            mainView.resultLabel.text = currentResult + bracket
        } else {
            mainView.resultLabel.text = bracket
        }
        stillTyping = true
    }
    
    @objc func getHistory() {
        let vc = HistoryController()
        if let history = UserSettings.historyArray {
            vc.historyView.historyItem = history
            present(vc, animated: true, completion: nil)
        } else {
            self.alertEmptyHistory()
        }
    }
    
    //MARK: - Expression
    //Методы для подсчета результата
    private func binaryOperation(_ operation: (Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        stillTyping = false
    }
    
    private func unaryOperation(_ operation: (Double) -> Double) {
        currentInput = operation(currentInput)
        stillTyping = false
    }
    
    private func bracketOperation(with expression: String) {
        let replaseExpression = expression.replaceOperations()
        let expression = NSExpression(format: replaseExpression)
        guard let result = expression.expressionValue(with: nil, context: nil) else {
            currentInput = 0
            isBrakets = false
            return
        }
        secondOperand = (result as AnyObject).doubleValue
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
            if !self.operationSymbol.containsOtherThan(.binaryOperations) {
                UserSettings.historyArray.insert("\(self.firstOperand) \(self.operationSymbol) \(self.secondOperand)", at: 0)
            }
        }
    }
}

