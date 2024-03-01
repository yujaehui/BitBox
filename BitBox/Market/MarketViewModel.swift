//
//  MarketViewModel.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import Foundation

class MarketViewModel {
    let repository = FavoriteCoinRepository()

    //input
    let inputMarket: Observable<String?> = Observable(nil)
    let inputIsFavoriteButtonClicked: Observable<FavoriteCoin?> = Observable(nil)
    let inputSetNavigationBar: Observable<String?> = Observable(nil)
    
    // output
    var outputCoinID: Observable<String> = Observable("")
    var outputFavoriteCoinList: Observable<[FavoriteCoin]> = Observable([])
    var outputToastMessage: Observable<String> = Observable("")
    var outputThumbImageView: Observable<String> = Observable("")
    var outputNameLabel: Observable<String> = Observable("")
    var outputCurrentPriceLabel: Observable<String> = Observable("")
    var outputPriceChangePercentageLabel: Observable<String> = Observable("")
    var outputPriceChangePercentageColor: Observable<Bool> = Observable(true)
    var outputHighPriceLabel: Observable<String> = Observable("")
    var outputLowPriceLabel: Observable<String> = Observable("")
    var outputAthLabel: Observable<String> = Observable("")
    var outputAtlLabel: Observable<String> = Observable("")
    var outputLastUpdateDateLabel: Observable<String> = Observable("")
    var outputChartView: Observable<[Double]> = Observable([])
    var outputSetNavigationBar: Observable<Bool> = Observable(false)
    var outputError: Observable<String?> = Observable(nil)
    
    
    init() {
        // 여기저기서 보낸 id가 들어올 때 nil이 아니면 네트워크 통신 및 패치
        // 네트워크 통신으로 뷰에 넣을 것들 데려와야 하고
        // 패치로 이게 즐겨찾기된 항목인지 확인해야 하니까
        inputMarket.bind { [weak self] value in
            guard let value = value else { return }
            self?.callRequest(ids: value)
            self?.outputFavoriteCoinList.value = self?.repository.fetchItem() ?? []
        }
        
        inputIsFavoriteButtonClicked.bind { [weak self] value in
            guard let value = value else { return }
            if let existingItem = self?.outputFavoriteCoinList.value.first(where: { $0.id == value.id }) {
                self?.repository.deleteItem(existingItem)// 이미 FavoriteCoinList에 있다면, realm에서 제거
                self?.outputFavoriteCoinList.value = self?.repository.fetchItem() ?? [] // fetch
                self?.outputToastMessage.value = "Remove from Favorite"
            } else if self?.outputFavoriteCoinList.value.count ?? 0 < 10 { // FavoriteCoinList의 항목의 수가 10개보다 작을 때만 추가 가능하도록
                self?.repository.createItem(value) // realm에 추가
                self?.outputFavoriteCoinList.value = self?.repository.fetchItem() ?? [] // fetch
                self?.outputToastMessage.value = "Add to Favorite"
            } else { // FavoriteCoinList의 항목이 10개를 넘었으면 추가도 삭제도 안하고 토스트 메시지만
                self?.outputToastMessage.value = "Only 10 favorites are available"
            }
        }
        
        inputSetNavigationBar.bind { value in
            guard let value = value else { return }
            if self.outputFavoriteCoinList.value.contains(where: { $0.id == value }) {
                self.outputSetNavigationBar.value = true
            } else {
                self.outputSetNavigationBar.value = false
            }
        }
    }
    
    private func callRequest(ids: String) {
        APIService.shared.fetchMarketCoinAPI(api: .market(ids: ids)) { [weak self] success, error in
            if error == nil {
                print("통신 성공")
                guard let success = success?.first else { return }
                self?.outputCoinID.value = success.id
                self?.outputThumbImageView.value = success.image
                self?.outputNameLabel.value = success.name
                self?.outputCurrentPriceLabel.value = NumberFormatterManager.shared.dollarFormatter(success.currentPrice)
                self?.outputPriceChangePercentageLabel.value = NumberFormatterManager.shared.percentageFormatter(success.priceChangePercentage24H)
                self?.outputPriceChangePercentageColor.value = success.priceChangePercentage24H >= 0 ? true : false
                self?.outputHighPriceLabel.value = NumberFormatterManager.shared.dollarFormatter(success.high24H)
                self?.outputLowPriceLabel.value = NumberFormatterManager.shared.dollarFormatter(success.low24H)
                self?.outputAthLabel.value = NumberFormatterManager.shared.dollarFormatter(success.ath)
                self?.outputAtlLabel.value = NumberFormatterManager.shared.dollarFormatter(success.atl)
                self?.outputLastUpdateDateLabel.value = DateFormatterManager.shared.dateFormatter(success.lastUpdated)
                self?.outputChartView.value = success.sparklineIn7D.price
                
                // FIXME: 값을 넣어주는 곳이 테이블뷰의 셀이 아니고 단순히 레이블
                // 이렇게 처음부터 각각 결과 값을 넣어주는 것이 맞을지, 아니면 success로 받아서 뷰컨 configureView에서 값을 넣어주는 것이 맞을지에 대한 고민
                // success만 받아서 configureView에 넣어주게 되면 success의 특정 항목이 바뀔 때마다 configureView를 다시 불러줘야 하기 때문에 영향을 받지 않는 것들도 다시 그리게 됨
                // 그러나 이렇게 각각 결과 값을 넣어주게 되면, 해당 bind의 클로저만 실행되고, 다른 Observable의 bind 클로저는 실행되지 않음
                
            } else {
                print("통신 실패")
                self?.outputError.value = "Too many requests.\nPlease try again in a moment."
            }
        }
    }
}
