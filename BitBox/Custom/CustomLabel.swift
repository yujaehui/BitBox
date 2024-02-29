//
//  CustomLabel.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/29/24.
//

import UIKit

class CustomLabel: UILabel {
    enum labelType {
        case largeTitle
        case header
        case rank
        case high
        case low
        case price1
        case price2
        case price3
        case name
        case symbol
        case priceChange1
        case priceChange2
        case priceChange3
        case date1
        case date2
        
        var font: UIFont {
            switch self {
            case .largeTitle: FontStyle.largeTitle
            case .header, .rank: FontStyle.semiLargeTitle
            case .high, .low: FontStyle.title
            case .price1: FontStyle.semiTitle
            case .price2: FontStyle.primaryBold
            case .price3: FontStyle.primary
            case .priceChange1: FontStyle.primaryBold
            case .priceChange2: FontStyle.secondaryBold
            case .priceChange3: FontStyle.secondary
            case .name: FontStyle.primaryBold
            case .symbol: FontStyle.secondaryBold
            case .date1: FontStyle.primaryBold
            case .date2: FontStyle.secondaryBold
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .largeTitle, .header: ColorStyle.black
            case .rank: ColorStyle.darkGray
            case .high: ColorStyle.red
            case .low: ColorStyle.blue
            case .price1: ColorStyle.darkGray
            case .price2: ColorStyle.black
            case .price3: ColorStyle.darkGray
            case .priceChange1, .priceChange2, .priceChange3: ColorStyle.gray // 색상 변경 예정
            case .name: ColorStyle.black
            case .symbol, .date1, .date2: ColorStyle.gray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(type: labelType) {
        self.init(frame: .zero)
        configureView(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ type: labelType) {
        textColor = type.textColor
        font = type.font
    }
}
