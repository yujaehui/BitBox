//
//  FavoriteCoinRepository.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import Foundation
import RealmSwift

class FavoriteCoinRepository {
    let realm = try! Realm()
    
    // create
    func createItem(_ item: FavoriteCoin) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    // fetch
    func fetchItem() -> [FavoriteCoin] {
        let result = realm.objects(FavoriteCoin.self)
        return Array(result)
    }
    
    // delete
    func deleteItem(_ item: FavoriteCoin) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
}
