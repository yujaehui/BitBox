//
//  NumberFormatterManager.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import Foundation

class NumberFormatterManager {
    static var shared = NumberFormatterManager()
    private init() {}
    
    let formatter = NumberFormatter()
    
    func dollarFormatter(_ price: Double) -> String {
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // 미국 달러
        if let formattedAmount = formatter.string(from: NSNumber(value: price)) {
            return formattedAmount
        } else {
            return "\(price)"
        }
    }
    
    func percentageFormatter(_ percentage: Double) -> String {
        return String(format: "%.2f", percentage) + "%"
    }
}
