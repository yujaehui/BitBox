//
//  CoinAPI.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import Foundation
import Alamofire

enum CoinAPI {
    case search(query: String)
    case market(ids: String)
    case trend
    
    var baseURL: String {
        return "https://api.coingecko.com/api/v3/"
    }
    
    var endpoint: URL {
        switch self {
        case .search: return URL(string: baseURL + "search")!
        case .market: return URL(string: baseURL + "coins/markets")!
        case .trend: return URL(string: baseURL + "search/trending")!
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .search(let query):
            ["query" : query]
        case .market(let ids):
            ["vs_currency" : "usd", "ids" : ids, "sparkline" : "true"]
        case .trend:
            [:]
        }
    }
}
