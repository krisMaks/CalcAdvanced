//
//  Double.swift
//  CalcAdvanced
//
//  Created by Кристина Максимова on 01.06.2022.
//

import Foundation

extension Double {
    func roundWithRule(_ first: Double, _ second: Double) -> Double {
        let value = String(first).count >= String(second).count ? String(first) : String(second)
        let components = value.components(separatedBy: ".")
        let result = pow(10.0, Double(components[1].count))
        return Darwin.round(self * result)/result
    }
}
