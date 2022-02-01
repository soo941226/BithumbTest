//
//  CDCoin.swift
//  BithumbTest
//
//  Created by kjs on 2022/02/01.
//

import CoreData

extension CDCoin {
    static let symbol = "symbol"
    static let isFavorite = "isFavorite"
    static func updateFavoriteCoin(symbol: Symbol?, isFavorite: Bool) {
        guard let symbol = symbol else { return }
        
        if isFavorite {
            CDManager.shared.insert(model: CDCoin.self) { coin in
                coin.setValue(symbol, forKey: CDCoin.symbol)
                coin.setValue(true, forKey: CDCoin.isFavorite)
            }
        } else {
            CDManager.shared.deleteAll(
                model: CDCoin.self,
                filter: NSPredicate(format: "symbol == %@", symbol)
            )
        }
    }
}
