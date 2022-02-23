//
//  ViewController.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import UIKit

class MainViewController: UIViewController {
    //Создание необходимых UI-элементов, констант и переменных
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 35)
        label.textColor = .white
        label.textAlignment = .right
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let historyButton: UIButton = {
        let button = UIButton(type: .system)
        button.addStyleHistoryButton()
        button.addTarget(self, action: #selector(getHistory), for: .touchUpInside)
        return button
    }()
    private let resultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let firstLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let secondLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let thirdLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let fourthLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let fifthLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    private let namesSharedButton: [[String]] = [["AC", "x²", "x³", "xª", "÷"], ["MC", "7", "8", "9", "×"], ["M＋", "4", "5", "6", "-"], ["M౼", "1", "2", "3", "+"], ["MR", "±", "0", ".", "="]]
    private let namesCompactButton: [[String]] = [["π", "AC", "x²", "x³", "xª", "÷"], ["e", "MC", "7", "8", "9", "×"], ["sin", "M＋", "4", "5", "6", "-"], ["cos", "M౼", "1", "2", "3", "+"], ["tan", "MR", "±", "0", ".", "="]]
    private let namesRegularButton: [[String]] = [["(", "π", "AC", "x²", "x³", "xª", "÷"], [")", "e", "MC", "7", "8", "9", "×"], ["√", "sin", "M＋", "4", "5", "6", "-"], ["∛", "cos", "M౼", "1", "2", "3", "+"], ["%", "tan", "MR", "±", "0", ".", "="]]
    private var buttons = [[UIButton]]()
    private var firstOperand: Double = 0
    private var secondOperand: Double = 0
    private var memory: [Double] = [0]
    private var operationSymbol: String = ""
    private var isDot = false
    private var stillTyping = false
    private var isBrakets = false
    
    private var currentInput: Double {
        get {
            return Double(resultLabel.text ?? "0") ?? 0
        }
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                resultLabel.text = "\(valueArray[0])"
            } else {
                resultLabel.text = "\(newValue)"
            }
            stillTyping = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    //MARK: - Setings view
    //Добавление subview на view
    private func setupView() {
        verticalStackView.addArrangedSubview(firstLineStackView)
        verticalStackView.addArrangedSubview(secondLineStackView)
        verticalStackView.addArrangedSubview(thirdLineStackView)
        verticalStackView.addArrangedSubview(fourthLineStackView)
        verticalStackView.addArrangedSubview(fifthLineStackView)
        resultView.addSubview(historyButton)
        resultView.addSubview(resultLabel)
        view.addSubview(resultView)
        view.addSubview(verticalStackView)
    }
    //Установка констрейнтов для элементов
    private func setConstraints() {
        sharedConstraints = resultView.addConstraints(top: view.safeAreaLayoutGuide.topAnchor,
                                                      leading: view.safeAreaLayoutGuide.leadingAnchor,
                                                      trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                                      height: view.heightAnchor,
                                                      multiplier: 0.2)
        sharedConstraints += historyButton.addConstraints(top: resultView.topAnchor,
                                                          trailing: resultView.trailingAnchor,
                                                          trailingConstant: -10,
                                                          height: 25,
                                                          width: 100)
        sharedConstraints += resultLabel.addConstraints(bottom: resultView.bottomAnchor,
                                                        trailing: resultView.trailingAnchor,
                                                        leading: resultView.leadingAnchor,
                                                        trailingConstant: -10,
                                                        leadingConstant: 10,
                                                        height: 40)
        sharedConstraints += verticalStackView.addConstraints(top: resultView.bottomAnchor,
                                                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                                                              trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    //Создание кнопок для различных рахмеров экрана и добавление target для них
    private func setButtons(with namesButton: [[String]]) {
        var newButtons = [UIButton]()
        for namesLine in namesButton {
            for name in namesLine {
                let button = UIButton(type: .system)
                button.addStyleMainButton()
                button.setTitle(name, for: .normal)
                newButtons.append(button)
                if !name.containsOtherThan(.nums) {
                    button.backgroundColor = UIColor(named: "grayButton")
                } else if !name.containsOtherThan(.mainOperations) {
                    button.backgroundColor = UIColor(named: "orangeButton")
                } else {
                    button.backgroundColor = UIColor(named: "darkGrayButton")
                }
                if !name.containsOtherThan(.nums) {
                    button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
                }
                if !name.containsOtherThan(.binaryOperations) {
                    button.addTarget(self, action: #selector(binaryOperatorPressed), for: .touchUpInside)
                }
                if !name.containsOtherThan(.equal) {
                    button.addTarget(self, action: #selector(equalPressed), for: .touchUpInside)
                }
                if !name.containsOtherThan(.dot) {
                    button.addTarget(self, action: #selector(dotOperatorPressed), for: .touchUpInside)
                }
                if !name.containsOtherThan(.unaryOperations) {
                    button.addTarget(self, action: #selector(unaryOperatorPressed), for: .touchUpInside)
                }
                if !name.containsOtherThan(.other) {
                    button.addTarget(self, action: #selector(otherOperatorPressed), for: .touchUpInside)
                }
                if !name.containsOtherThan(.percent) {
                    button.addTarget(self, action: #selector(persentOperatorPressed), for: .touchUpInside)
                }
                if !name.containsOtherThan(.memory) {
                    button.addTarget(self, action: #selector(memoryOperatorPressed), for: .touchUpInside)
                }
                if !name.containsOtherThan(.bracket) {
                    button.addTarget(self, action: #selector(bracketPressed), for: .touchUpInside)
                }
            }
            buttons.append(newButtons)
            newButtons.removeAll()
        }
    }
    //Размещение кнопок в горизонтальных stackView
    private func setView(with namesButtons: [[String]]) {
        let stacks = [firstLineStackView, secondLineStackView, thirdLineStackView, fourthLineStackView, fifthLineStackView]
        removeViewInStack()
        setButtons(with: namesButtons)
        for (index, buttonsLine) in buttons.enumerated() {
            for button in buttonsLine {
                stacks[index].addArrangedSubview(button)
            }
        }
    }
    //Вспомогательный метод для очистки subview в stackView
    private func removeViewInStack() {
        let stacks = [firstLineStackView, secondLineStackView, thirdLineStackView, fourthLineStackView, fifthLineStackView]
        for stack in stacks {
            for view in stack.arrangedSubviews {
                stack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        buttons.removeAll()
    }
    
    //MARK: - Change layout
    //Метод для получения текущего размера экрана, используется в traitCollectionDidChange()
    private func layoutTrait(traitCollection: UITraitCollection) {
        NSLayoutConstraint.activate(sharedConstraints)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            setView(with: namesSharedButton)
        } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            setView(with: namesRegularButton)
        } else {
            setView(with: namesCompactButton)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    
    //MARK: - Targets
    //Target для кнопок
    @objc func numberPressed(_ sender: UIButton) {
        guard let number = sender.currentTitle, let currentResult = resultLabel.text else { return }
        if stillTyping {
            if currentResult.count < 12 {
                resultLabel.text = currentResult + number
            }
        } else if isBrakets {
            stillTyping = true
            resultLabel.text = currentResult + number
        } else {
            resultLabel.text = number
            stillTyping = true
        }
    }
    
    @objc func binaryOperatorPressed(_ sender: UIButton) {
        guard let binaryOperator = sender.currentTitle, let currentResult = resultLabel.text else { return }
        if isBrakets {
            resultLabel.text = currentResult + binaryOperator
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
        firstOperand = currentInput
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
    }
    
    @objc func equalPressed(_ sender: UIButton) {
        guard let currentResult = resultLabel.text else { return }
        if stillTyping && !isBrakets {
            secondOperand = currentInput
        }
        if isBrakets {
            stillTyping = false
            if currentResult.numberBrackets() {
                let replaseExpression = currentResult.replaceOperations()
                let expression = NSExpression(format: replaseExpression)
                guard let result = expression.expressionValue(with: nil, context: nil) else { currentInput = 0
                    isBrakets = false
                    return
                }
                secondOperand = (result as AnyObject).doubleValue
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
        firstOperand = currentInput
        stillTyping = false
        switch operationSymbol {
        case "MC":
            memory = [0]
        case "M＋":
            memory.append(firstOperand + memory.last!)
        case "M౼":
            memory.append(firstOperand - memory.last!)
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
        guard let currentResult = resultLabel.text else { return }
        if stillTyping && !isDot {
            resultLabel.text = currentResult + "."
            isDot = true
        } else if !stillTyping && !isDot {
            resultLabel.text = "0."
            isDot = true
            stillTyping = true
        }
    }
    
    @objc func otherOperatorPressed(_ sender: UIButton) {
        guard let otherOperator = sender.currentTitle else { return }
        operationSymbol = otherOperator
        firstOperand = currentInput
        stillTyping = false
        
        switch operationSymbol {
        case "π":
            currentInput = Double.pi
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
        default: break
        }
    }
    
    @objc func bracketPressed(_ sender: UIButton) {
        guard let bracket = sender.currentTitle, let currentResult = resultLabel.text else { return }
        isBrakets = true
        if stillTyping {
            resultLabel.text = currentResult + bracket
        } else {
            resultLabel.text = bracket
        }
        stillTyping = true
    }
    
    @objc func getHistory() {
        let vc = HistoryController()
        if let history = UserSettings.historyArray {
            vc.historyItem = history
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
        currentInput = operation(firstOperand)
        stillTyping = false
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

