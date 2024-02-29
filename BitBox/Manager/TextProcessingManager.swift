//
//  TextProcessingManager.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/29/24.
//

import Foundation
import UIKit

class TextProcessingManager {
    static let shared = TextProcessingManager()
    private init() {}
    
    // HTML 제거
    func removeHTMLTags(from string: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "<[^>]+>", options: [])
            let range = NSRange(location: 0, length: string.utf16.count)
            let withoutHTML = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
            return withoutHTML
        } catch {
            print("Error removing HTML tags: \(error.localizedDescription)")
            return string
        }
    }
    
    // 검색어와 일치하는 부분을 다른 색상으로 강조
    func textColorChange(_ text: String, changeText: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: changeText, options: .caseInsensitive)
        attributedText.addAttribute(.foregroundColor, value: ColorStyle.purple, range: range)
        return attributedText
    }
}
