//
//  FavoriteCoin.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import Foundation
import RealmSwift

class FavoriteCoin: Object {
    @Persisted(primaryKey: true) var pk: ObjectId
    @Persisted var id: String
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}
