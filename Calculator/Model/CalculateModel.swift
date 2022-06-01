//
//  CalculateModel.swift
//  CalcAdvanced
//
//  Created by Кристина Максимова on 31.05.2022.
//

import Foundation


struct CalculateModel {
    private(set) var firstOperand: Double = 0
    private(set) var secondOperand: Double = 0
    private var memory: [Double] = [0]
    private(set) var operationSymbol: String = ""
    private var isDot = false
    var stillTyping = false
    private var isBrakets = false
//    var currentInput: String = "0"
//    var currentResult: String = "0"
//    private var currentInput: Double {
//        get {
//            return Double(mainView.resultLabel.text ?? "0") ?? 0
//        }
//        set {
//            let value = "\(newValue)"
//            let valueArray = value.components(separatedBy: ".")
//            if valueArray[1] == "0" {
//                mainView.resultLabel.text = "\(valueArray[0])"
//            } else {
//                mainView.resultLabel.text = "\(newValue)"
//            }
//            stillTyping = false
//        }
//    }
    
    mutating func numberPressed(_ numberText: String, _ resultLabelText: String) -> String? {
        if stillTyping && isBrakets {
            if resultLabelText.count < 12 {
                return resultLabelText + numberText
            }
        } else if isBrakets {
            stillTyping = true
            return resultLabelText + numberText
        } else {
            stillTyping = true
            return numberText
        }
        return nil
    }
    
    mutating func binaryOperatorPressed(_ binaryOperator: String, _ currentResult: String, _ currentInp: Double) -> String? {
        if isBrakets {
            return currentResult + binaryOperator
        } else {
            operationSymbol = binaryOperator
            firstOperand = currentInp
            stillTyping = false
            isDot = false
            return nil
        }
    }
    
    mutating func unaryOperatorPressed(_ unaryOperator: String, _ currentInput: Double) -> Double? {
        operationSymbol = unaryOperator
        stillTyping = false
        isDot = false
        switch operationSymbol {
        case "x²":
            return unaryOperation(currentInput) { pow($0, 2) }
        case "x³":
            return unaryOperation(currentInput) { pow($0, 3) }
        case "√":
            return unaryOperation(currentInput) { sqrt($0) }
        case "sin":
            return unaryOperation(currentInput) { sin($0) }
        case "cos":
            return unaryOperation(currentInput) { cos($0) }
        case "tan":
            return unaryOperation(currentInput) { tan($0) }
        case "∛":
            return unaryOperation(currentInput) { cbrt($0) }
        case "±":
            if currentInput != 0 {
                return currentInput * -1
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    private mutating func binaryOperation(_ operation: (Double, Double) -> Double) -> Double {
        stillTyping = false
        isBrakets = false
        isDot = false
        return operation(firstOperand, secondOperand)
    }
    
    private mutating func unaryOperation(_ currentInput: Double, _ operation: (Double) -> Double) -> Double {
        stillTyping = false
        if firstOperand != 0 {
            secondOperand = operation(currentInput)
        } else {
            firstOperand = operation(currentInput)
        }
        return operation(currentInput)
    }
    
    mutating func equalPressed(_ currentResult: String, _ currentInput: Double) -> Double? {
        if stillTyping && !isBrakets {
            secondOperand = currentInput
        }
        if isBrakets {
            stillTyping = false
            if currentResult.numberBrackets() {
                return bracketOperation(with: currentResult) ?? 0
            } else {
                isBrakets = false
                return 0
            }
        }
        switch operationSymbol {
        case "+":
            return binaryOperation { $0 + $1 }
        case "-":
            return binaryOperation { $0 - $1 }
        case "÷":
            if secondOperand != 0 {
                return binaryOperation { $0 / $1 }
            } else {
                return 0
            }
        case "×":
            return binaryOperation { $0 * $1 }
        case "xª":
            return binaryOperation { pow($0, $1) }
        default:
            return binaryOperation { $0 + $1 }
        }
        
    }
    
    private mutating func bracketOperation(with expression: String) -> Double? {
        let replaseExpression = expression.replaceOperations()
        let expression = NSExpression(format: replaseExpression)
        guard let result = expression.expressionValue(with: nil, context: nil) else {
            isBrakets = false
            return 0
        }
        secondOperand = (result as AnyObject).doubleValue
        return nil
    }
    
    mutating func memoryOperatorPressed(_ memoryOperator: String, _ currentInput: Double) -> Double? {
        operationSymbol = memoryOperator
        stillTyping = false
        switch operationSymbol {
        case "MC":
            memory = [0]
            return nil
        case "M＋":
            memory.append(currentInput + memory.last!)
            return nil
        case "M౼":
            memory.append(currentInput - memory.last!)
            return nil
        case "MR":
            return memory.last!
        default:
            return nil
        }
    }
    
    mutating func persentOperatorPressed(_ currentInput: Double) -> Double? {
        stillTyping = false
        if firstOperand == 0 {
            return currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
            return nil
        }
    }
    
    mutating func dotOperatorPressed(_ currentResult: String) -> String? {
        if stillTyping && !isDot {
            isDot = true
            return currentResult + "."
        } else if !stillTyping && !isDot {
            isDot = true
            stillTyping = true
            return "0."
        } else {
            isDot = true
            return nil
        }
    }
    
    mutating func otherOperatorPressed(_ otherOperator: String, _ currentInput: Double) -> Double? {
        operationSymbol = otherOperator
        stillTyping = false
        
        switch operationSymbol {
        case "π":
            if firstOperand != 0 {
                secondOperand = currentInput
            } else {
                firstOperand = currentInput
            }
            return Double.pi
        case "AC":
            firstOperand = 0
            secondOperand = 0
            operationSymbol = ""
            stillTyping = false
            isDot = false
            isBrakets = false
            return 0
        case "e":
            if firstOperand != 0 {
                secondOperand = currentInput
            } else {
                firstOperand = currentInput
            }
            return exp(1)
        default:
            return nil
        }
    }
    
    mutating func bracketPressed(_ bracket: String, _ currentResult: String) -> String {
        isBrakets = true
        if stillTyping {
            return currentResult + bracket
        } else {
            stillTyping = true
            return bracket
        }
    }
}
