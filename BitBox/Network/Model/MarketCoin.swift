//
//  MarketCoin.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import Foundation

// MARK: - MarketCoin
struct MarketCoin: Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let high24H, low24H: Double
    let priceChangePercentage24H: Double
    let ath: Double
    let athDate: String
    let atl: Double
    let atlDate: String
    let lastUpdated: String
    let sparklineIn7D: SparklineIn7D

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case ath
        case athDate = "ath_date"
        case atl
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
    }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]
}
