//
//  String.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import Foundation

extension String {
    enum Chars: String {
        case mainOperations = "÷×-+="
        case nums = "0123456789"
        case binaryOperations = "÷×-+xª"
        case equal = "="
        case unaryOperations = "x²x³√sin∛costan±"
        case dot = "."
        case percent = "%"
        case bracket = "()"
        case other = "πACe"
        case memory = "M＋C౼R"
    }
    
    func containsOtherThan(_ chars: Chars) -> Bool {
        let set = CharacterSet(charactersIn: chars.rawValue)
        return self.rangeOfCharacter(from: set.inverted) != nil
    }
    
    func numberBrackets() -> Bool {
        var openBracket = 0
        var closeBracket = 0
        for char in self {
            if char == "(" {
                openBracket += 1
            } else if char == ")" {
                closeBracket += 1
            }
        }
        if openBracket == closeBracket {
            return true
        } else {
            return false
        }
    }
    
    func replaceOperations() -> String {
        var replaceString = self.replacingOccurrences(of: "÷", with: "/")
        replaceString = replaceString.replacingOccurrences(of: "×", with: "*")
        return replaceString
    }
}
