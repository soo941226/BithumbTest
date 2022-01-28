//
//  WSOrderbook.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/28.
//

import Foundation

class WSOrderbook {
    let symbol: String?
    let orderType: OrderType?
    let stuff: Stuff?
    let total: String?

    init?(origin: [String: Any]) {
        let dictionary: [String: String] = origin.compactMapValues { any in
            return any as? String
        }

        for key in CodingKeys.allCases {
            guard dictionary[key.rawValue] != nil else {
                return nil
            }
        }
        guard let price = Double(dictionary[CodingKeys.price.rawValue]!),
              let quantity = Double(dictionary[CodingKeys.quantity.rawValue]!) else {
                  return nil
              }

        symbol = dictionary[CodingKeys.symbol.rawValue]
        orderType = OrderType(rawValue: dictionary[CodingKeys.orderType.rawValue]!)
        stuff = Stuff(quantity: quantity, price: price)
        total = dictionary[CodingKeys.total.rawValue]
    }

    enum OrderType: String {
        case bid
        case ask
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case symbol, orderType, price, quantity, total
    }
}
