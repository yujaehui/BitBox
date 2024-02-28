//
//  TrendCoin.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import Foundation

// MARK: - TrendCoin
struct TrendCoin: Codable {
    let coins: [TopCoin]
    let nfts: [TopNFT]
}

// MARK: - TopCoin
struct TopCoin: Codable {
    let item: Item
}

// MARK: - Item
struct Item: Codable {
    let id: String
    let thumb: String
    let name: String
    let symbol: String
    let data: ItemData
}

// MARK: - ItemData
struct ItemData: Codable {
    let price: Double
    let priceChangePercentage24H: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case price
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
}

// MARK: - TopNFT
struct TopNFT: Codable {
    let id: String
    let thumb: String
    let name: String
    let symbol: String
    let floorPrice24hPercentageChange: Double
    let data: NftData
    
    enum CodingKeys: String, CodingKey {
        case id
        case thumb
        case name
        case symbol
        case floorPrice24hPercentageChange = "floor_price_24h_percentage_change"
        case data
    }
}

// MARK: - NTFData
struct NftData: Codable {
    let floorPrice: String
    
    enum CodingKeys: String, CodingKey {
        case floorPrice = "floor_price"
    }
}
