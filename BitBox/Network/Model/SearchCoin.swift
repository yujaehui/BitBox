//
//  SearchCoin.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import Foundation

// MARK: - SearchCoin
struct SearchCoin: Codable {
    let coins: [Coin]
}

// MARK: - Coin
struct Coin: Codable {
    let id, name, symbol: String
    let marketCapRank: Int
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case marketCapRank = "market_cap_rank"
        case thumb
    }
}
