//
//  CDCoin.swift
//  BithumbTest
//
//  Created by kjs on 2022/02/01.
//

import CoreData

extension CDCoin {
    static func updateFavoriteCoin(symbol: Symbol?, isBookmarked: Bool) {
        guard let symbol = symbol else { return }
        
        if isBookmarked {
            CDManager.shared.insert(model: CDCoin.self) { coin in
                coin.setValue(symbol, forKey: "symbol")
                coin.setValue(true, forKey: "isBookmarked")
            }
        } else {
            CDManager.shared.deleteAll(
                model: CDCoin.self,
                filter: NSPredicate(format: "symbol == %@", symbol)
            )
        }
    }
}
