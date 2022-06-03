//
//  CalculateModel.swift
//  CalcAdvanced
//
//  Created by Кристина Максимова on 31.05.2022.
//

import Foundation
import Expression

struct CalculateModel {
    var stillTyping = false
    private(set) var firstOperand: Double = 0
    private(set) var secondOperand: Double = 0
    private(set) var operationSymbol: String = ""
    private var memory: [Double] = [0]
    private var isBrakets = false
    private var isDot = false
    
    mutating func numberInput(_ numberText: String, _ resultLabelText: String) -> String? {
        if stillTyping {
            if resultLabelText != "0" {
                return resultLabelText + numberText
            } else {
                return numberText
            }
        } else if isBrakets {
            stillTyping = true
            return resultLabelText + numberText
        } else {
            stillTyping = true
            return numberText
        }
    }
    
    mutating func binaryOperatorInput(_ binaryOperator: String, _ currentResult: String, _ currentInp: Double) -> String? {
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
    
    mutating func unaryOperatorInput(_ unaryOperator: String, _ currentInput: Double) -> Double? {
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
            return unaryOperation(currentInput) { sin(Double.pi * $0 / 180.0) }
        case "cos":
            return unaryOperation(currentInput) { cos(Double.pi * $0 / 180.0) }
        case "tan":
            return unaryOperation(currentInput) { tan(Double.pi * $0 / 180.0) }
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
    
    mutating func memoryOperatorInput(_ memoryOperator: String, _ currentInput: Double) -> Double? {
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
    
    mutating func persentInput(_ currentInput: Double) -> Double? {
        stillTyping = false
        if firstOperand == 0 {
            return currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
            return secondOperand
        }
    }
    
    mutating func dotInput(_ currentResult: String) -> String? {
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
    
    mutating func otherOperatorInput(_ otherOperator: String, _ currentInput: Double) -> Double? {
        operationSymbol = otherOperator
        stillTyping = false
        
        switch operationSymbol {
        case "π":
            if firstOperand != 0 {
                secondOperand = currentInput
                firstOperand = Double.pi
            } else {
                firstOperand = currentInput
                secondOperand = Double.pi
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
                firstOperand = exp(1)
            } else {
                firstOperand = currentInput
                secondOperand = exp(1)
            }
            return exp(1)
        default:
            return nil
        }
    }
    
    mutating func bracketInput(_ bracket: String, _ currentResult: String) -> String {
        isBrakets = true
        if stillTyping {
            return currentResult + bracket
        } else {
            stillTyping = true
            return bracket
        }
    }
    
    mutating func equalOperation(_ currentResult: String, _ currentInput: Double) -> Double? {
        if isBrakets {
            stillTyping = false
            isBrakets = false
            secondOperand = bracketOperation(with: currentResult)
        } else {
            secondOperand = currentInput
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
                return nil
            }
        case "×":
            return binaryOperation { $0 * $1 }
        case "xª":
            return binaryOperation { pow($0, $1) }
        default:
            operationSymbol = "+"
            return binaryOperation { $0 + $1 }
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
    
    private mutating func bracketOperation(with expression: String) -> Double {
        let replaseExpression = expression.replaceOperations()
        do {
            let expression = Expression(replaseExpression)
            let result = try expression.evaluate()
            return result
        } catch {
            isBrakets = false
            return 0
        }
    }
}
