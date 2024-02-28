//
//  APIService.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchSearchCoinAPI(api: CoinAPI, completionHandler: @escaping (SearchCoin) -> Void) {
        AF.request(api.endpoint, parameters: api.parameter).responseDecodable(of: SearchCoin.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure( _):
                print("search error")
            }
        }
    }
    
    func fetchMarketCoinAPI(api: CoinAPI, completionHandler: @escaping ([MarketCoin]?, Error?) -> Void) {
        AF.request(api.endpoint, parameters: api.parameter).responseDecodable(of: [MarketCoin].self) { response in
            switch response.result {
            case .success(let success):
                print(#function)
                completionHandler(success, nil)
            case .failure(let error):
                print("market error")
                completionHandler(nil, error)
            }
        }
    }
    
    
    func fetchTrendCoinAPI(api: CoinAPI, completionHandler: @escaping (TrendCoin) -> Void) {
        AF.request(api.endpoint).responseDecodable(of: TrendCoin.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure( _):
                print("trend error")
            }
        }
    }
}
