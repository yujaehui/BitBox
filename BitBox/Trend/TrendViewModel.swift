//
//  TrendViewModel.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import Foundation

class TrendViewModel {
    let repository = FavoriteCoinRepository()
    
    // input
//    let inputViewWillAppear: Observable<[MarketCoinElement]?> = Observable(nil)
    let inputRefresh: Observable<[MarketCoin]> = Observable([])
    let inputCurrentPriceLabel: Observable<Double> = Observable(0)
    let inputPriceChangePercentageLabel: Observable<Double> = Observable(0)
    let inputPriceLabel: Observable<String> = Observable("")
    
    // output
    var outputFavoriteCoinList: Observable<[FavoriteCoin]> = Observable([])
    var outputMarketCoinList: Observable<[MarketCoin]> = Observable([])
    var outputTrendCoinList: Observable<TrendCoin> = Observable(TrendCoin(coins: [], nfts: []))
    var outputError: Observable<String?> = Observable(nil)
    
    // transition
    var DidSelectItemAt: Observable<String?> = Observable(nil)
    
    init() {
        trendCallRequest()
        
//        inputViewWillAppear.bind { value in
//            guard let value = value else { return } // nil이면 클로저 실행 X
//
//            self.outputFavoriteCoinList.value = self.repository.fetchItem() // fetch
//            print(self.outputFavoriteCoinList.value.count, value.count) // 어디선가 별을 눌렀다면 여기서 차이가 발생
//
//            // 패치는 진행되었지만, 네트워크 통신은 하지 않은 상태
//            if self.outputFavoriteCoinList.value.count != value.count && self.outputFavoriteCoinList.value.count != 0 {
//                // favorite과 market의 수가 다르고, favorite의 수가 0이 아니면 네트워크 통신 진행
//                self.marketCallRequest(ids: self.outputFavoriteCoinList.value.map{ $0.id }.joined(separator: ", "))
//
//            } else if self.outputFavoriteCoinList.value.count != value.count && self.outputFavoriteCoinList.value.count == 0 {
//                // favorite과 market의 수가 다르고, favorite의 수가 0이면 market 전부 제거
//                // 이 경우에도 네트워크 통신을 해도 문제가 없을 줄 알았으나... ids에 아무것도 안 넣어주면 자기 마음대로 인기순인지 뭔지 가져옴
//                self.outputMarketCoinList.value.removeAll()
//
//            } else {
//                // 그게 아니면 아무런 변화가 없기 때문에 아무것도 해줄 필요 없음
//                return
//            }
//        }
        
        // 새로고침으로 변경
        inputRefresh.bind { value in
            self.outputFavoriteCoinList.value = self.repository.fetchItem() // fetch
            print(self.outputFavoriteCoinList.value.count, value.count) // 어디선가 별을 눌렀다면 여기서 차이가 발생
            
            // 패치는 진행되었지만, 네트워크 통신은 하지 않은 상태
            if self.outputFavoriteCoinList.value.count != value.count && self.outputFavoriteCoinList.value.count != 0 {
                // favorite과 market의 수가 다르고, favorite의 수가 0이 아니면 네트워크 통신 진행
                self.marketCallRequest(ids: self.outputFavoriteCoinList.value.map{ $0.id }.joined(separator: ", "))
                
            } else if self.outputFavoriteCoinList.value.count != value.count && self.outputFavoriteCoinList.value.count == 0 {
                // favorite과 market의 수가 다르고, favorite의 수가 0이면 market 전부 제거
                // 이 경우에도 네트워크 통신을 해도 문제가 없을 줄 알았으나... ids에 아무것도 안 넣어주면 자기 마음대로 인기순인지 뭔지 가져옴
                self.outputMarketCoinList.value.removeAll()
                
            } else {
                // 그게 아니면 아무런 변화가 없기 때문에 아무것도 해줄 필요 없음
                return
            }
        }
    }
    
    // My Favorite 섹션
    private func marketCallRequest(ids: String) {
        APIService.shared.fetchMarketCoinAPI(api: CoinAPI.market(ids: ids)) { [weak self] success, error in
            if error == nil {
                print("통신 성공")
                self?.outputMarketCoinList.value = success ?? []
            } else {
                print("통신 실패")
                self?.outputError.value = "Favorite update failed.\nPlease try again in a moment."
            }
        }
    }
    
    // Top 15 Coin, Top 7 NFT 섹션
    private func trendCallRequest() {
        APIService.shared.fetchTrendCoinAPI(api: CoinAPI.trend) { [weak self] success in
            self?.outputTrendCoinList.value = success
        }
    }
}
