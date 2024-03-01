//
//  FavoriteViewModel.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import Foundation

class FavoriteViewModel {
    let repository = FavoriteCoinRepository()
    
    // input
//    let inputViewWillAppear: Observable<[MarketCoinElement]?> = Observable(nil)
    let inputRefresh: Observable<[MarketCoin]> = Observable([])
    
    // output
    var outputFavoriteCoinList: Observable<[FavoriteCoin]> = Observable([])
    var outputMarketCoinList: Observable<[MarketCoin]> = Observable([])
    var outputError: Observable<String?> = Observable(nil)
    
    // transition
    let DidSelectItemAt: Observable<String?> = Observable(nil)
    
    init() {
//        inputViewWillAppear.bind { value in
//            guard let value = value else { return } // nil이면 클로저 실행 X
//            self.outputFavoriteCoinList.value = self.repository.fetchItem()
//            print(self.outputFavoriteCoinList.value.count, value.count)
//            if self.outputFavoriteCoinList.value.count != value.count && self.outputFavoriteCoinList.value.count != 0 {
//                self.callRequest(ids: self.outputFavoriteCoinList.value.map{ $0.id }.joined(separator: ", "))
//            } else if self.outputFavoriteCoinList.value.count != value.count && self.outputFavoriteCoinList.value.count == 0 {
//                self.outputMarketCoinList.value.removeAll()
//            } else {
//                print("이전과 변화 X - FavoriteViewModel")
//            }
//        }
        
        // 원래는 위처럼 viewWillAppear 할 때마다 체크 >>> 새로고침 방식으로 변경
        inputRefresh.bind { [weak self] value in
            guard let self = self else { return }
            self.outputFavoriteCoinList.value = self.repository.fetchItem()
            print(self.outputFavoriteCoinList.value.count, self.outputMarketCoinList.value.count)
            
            if self.outputFavoriteCoinList.value.count != self.outputMarketCoinList.value.count &&
                self.outputFavoriteCoinList.value.count != 0 {
                self.callRequest(ids: self.outputFavoriteCoinList.value.map{ $0.id }.joined(separator: ", "))
            } else if self.outputFavoriteCoinList.value.count != self.outputMarketCoinList.value.count &&
                        self.outputFavoriteCoinList.value.count == 0 {
                self.outputMarketCoinList.value.removeAll()
            } else {
                print("변화 X")
            }
            
            // FIXME: 인스턴스 생성 시점에도 실행되길 원하면 이렇게 해도 되는지
            // 얘는 처음에도 실행되야 하니까 옵셔널 아니고 그냥 받기
            // viewWillAppear는 굳이 인스턴스 생성 시점에 실행되지 않아도 화면이 뜨는 순간 실행이 되기 때문에 옵셔널로 처리했으나
            // 얘는 새로고침을 하기 전에는 실행되지 않기 때문에 인스턴스 생성 시점에 실행되기 위해서 위처럼 처리
            // 아니면 옵셔널로 받고 viewDidLoad 시점 보내서 처리해야 하는지...
        }
    }
    
    func callRequest(ids: String) {
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
}
