//
//  OrderCurrency.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

enum OrderCurrency: Encodable {
    case BTC
    case ETH
    case ALL
    case etc(something: String)

    var value: String {
        switch self {
        case .BTC:
            return "BTC"
        case .ETH:
            return "ETH"
        case .ALL:
            return "ALL"
        case .etc(let something):
            return something
        }
    }
}
