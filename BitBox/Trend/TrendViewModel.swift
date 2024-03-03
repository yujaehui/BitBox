//
//  TrendViewModel.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import Foundation

// 캐시 엔트리 클래스 (데이터 + 만료 시간 저장)
private class CacheEntry {
    let data: [MarketCoin]
    let expirationDate: Date

    init(data: [MarketCoin], expirationDate: Date) {
        self.data = data
        self.expirationDate = expirationDate
    }
}

final class TrendViewModel {
    private let repository = FavoriteCoinRepository()
    
    // NSCache를 활용한 API 응답 캐싱 (자동 메모리 관리)
    private let cache = NSCache<NSString, CacheEntry>()

    
    // input
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
        
        inputRefresh.bind { [weak self] value in
            guard let self = self else { return }
            self.refreshFavoriteCoins(with: value)
        }
    }
    
    // 새로고침을 처리하는 함수 (네트워크 요청 최적화)
    private func refreshFavoriteCoins(with value: [MarketCoin]) {
        outputFavoriteCoinList.value = repository.fetchItem() // 로컬 데이터 패치
        print(outputFavoriteCoinList.value.count, value.count) // 변경 감지 로그
        
        let favoriteIds = outputFavoriteCoinList.value.map { $0.id }.joined(separator: ", ")
        
        // 캐시 확인 + 만료 시간 체크
        let now = Date()
        if let cacheEntry = cache.object(forKey: favoriteIds as NSString), now < cacheEntry.expirationDate {
            print("🔄 캐시에서 불러옴")
            outputMarketCoinList.value = cacheEntry.data
            return
        }

        // 네트워크 요청 조건 확인
        if !outputFavoriteCoinList.value.isEmpty {
            print("🌐 네트워크 요청 진행: \(favoriteIds)")
            marketCallRequest(ids: favoriteIds)
        } else {
            print("❌ Market 리스트 초기화")
            outputMarketCoinList.value.removeAll()
        }
    }
    
    // My Favorite 섹션 API 요청
    private func marketCallRequest(ids: String) {
        let cacheKey = ids as NSString
        let now = Date()

        // 네트워크 요청 후 캐싱
        APIService.shared.fetchMarketCoinAPI(api: CoinAPI.market(ids: ids)) { [weak self] success, error in
            guard let self = self else { return }
            
            if let successData = success {
                print("🌐 API 통신 성공 → 캐시에 저장: \(ids)")
                
                // 캐시 저장 + 10분 후 만료 설정
                let expirationTime = now.addingTimeInterval(600) // 10분 (600초)
                self.cache.setObject(CacheEntry(data: successData, expirationDate: expirationTime), forKey: cacheKey)
                
                self.outputMarketCoinList.value = successData
            } else {
                print("❌ API 통신 실패")
                self.outputError.value = "Favorite update failed.\nPlease try again in a moment."
            }
        }
    }
    
    // Top 15 Coin, Top 7 NFT 섹션 API 요청
    private func trendCallRequest() {
        APIService.shared.fetchTrendCoinAPI(api: CoinAPI.trend) { [weak self] success in
            guard let self = self else { return }
            self.outputTrendCoinList.value = success
        }
    }
}
