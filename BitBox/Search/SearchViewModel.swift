//
//  SearchViewModel.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/29/24.
//

import Foundation

class SearchViewModel {
    let repository = FavoriteCoinRepository()
    
    //input
    let inputViewWillAppear: Observable<Void?> = Observable(nil)
    let inputSearch: Observable<String?> = Observable(nil)
    let inputIsFavoriteButtonClicked: Observable<FavoriteCoin?> = Observable(nil)
    let inputCellForRowAt: Observable<Int?> = Observable(nil)
    
    // output
    var outputFavoriteCoinList: Observable<[FavoriteCoin]> = Observable([])
    var outputToastMessage: Observable<String> = Observable("")
    var outputSearchCoinList: Observable<[Coin]> = Observable([])
    var outputCellForRowAt: Observable<Bool> = Observable(true)
    
    // transition
    var DidSelectRowAt: Observable<String?> = Observable(nil)
    
    init() {
        // 해당 화면이 뜰 때마다 별이 눌렸는지 확인
        inputViewWillAppear.bind { _ in
            self.outputFavoriteCoinList.value = self.repository.fetchItem()
        }
        
        inputSearch.bind { [weak self] value in
            guard let value = value else { return }
            self?.searchCallRequest(query: value)
        }
        
        inputIsFavoriteButtonClicked.bind { [weak self] value in
            guard let value = value else { return }
            if let existingItem = self?.outputFavoriteCoinList.value.first(where: { $0.id == value.id }) {
                self?.repository.deleteItem(existingItem) // 이미 FavoriteCoinList에 있다면, realm에서 제거
                self?.outputFavoriteCoinList.value = self?.repository.fetchItem() ?? [] // fetch
                self?.outputToastMessage.value = "Remove from Favorite"
            } else if self?.outputFavoriteCoinList.value.count ?? 0 < 10 { // FavoriteCoinList의 항목의 수가 10개보다 작을 때만 추가 가능하도록
                self?.repository.createItem(value) // realm에 추가
                self?.outputFavoriteCoinList.value = self?.repository.fetchItem() ?? [] // fetch
                self?.outputToastMessage.value = "Add to Favorite"
            } else { // FavoriteCoinList의 항목이 10개를 넘었으면 추가도 삭제도 안하고 토스트 메시지만
                self?.outputToastMessage.value = "Only 10 favorites are available"
            }
            
            // FIXME: 패치를 자주 해도 상관이 없을지
            // 이렇게 컬럼을 추가, 제거할 때마다 패치를 매번해주는게 맞는지
            // 현재 이렇게 한 이유는 outputFavoriteCoinList가 변경될 때마다 뷰컨에서 테이블뷰 갱신이 필요하기 때문에
        }
        
        inputCellForRowAt.bind { value in
            guard let value = value else { return }
            if self.outputFavoriteCoinList.value.contains(where: { $0.id == self.outputSearchCoinList.value[value].id }) {
                self.outputCellForRowAt.value = true
            } else {
                self.outputCellForRowAt.value = false
            }
        }
    }
    
    private func searchCallRequest(query: String) {
        APIService.shared.fetchSearchCoinAPI(api: CoinAPI.search(query: query)) { [weak self] success in
            self?.outputSearchCoinList.value = success.coins
        }
    }
}
