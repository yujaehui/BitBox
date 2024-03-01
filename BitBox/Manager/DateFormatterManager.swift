//
//  DateFormatterManager.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}
    
    func dateFormatter(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = inputFormatter.date(from: dateString) else { return "" }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "M/d hh:mm:ss 업데이트"
        let formattedDate = outputFormatter.string(from: date)
        return formattedDate
    }
}
