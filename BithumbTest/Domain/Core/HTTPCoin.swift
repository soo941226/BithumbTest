//
//  HTTPCoin.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

import Foundation

struct HTTPCoin: Decodable {
    let symbol: Symbol?
    let openingPrice: String?
    let closingPrice: String?
    let minPrice: String?
    let maxPrice: String?
    let unitsTraded: String?
    let accTradeValue: String?
    let prevClosingPrice: String?
    let unitsTraded24H: String?
    let accTradeValue24H: String?
    let fluctate24H: String?
    let fluctateRate24H: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case symbol, date
        case openingPrice = "opening_price"
        case closingPrice = "closing_price"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case unitsTraded = "units_traded"
        case accTradeValue = "acc_trade_value"
        case prevClosingPrice = "prev_closing_price"
        case unitsTraded24H = "units_traded_24H"
        case accTradeValue24H = "acc_trade_value_24H"
        case fluctate24H = "fluctate_24H"
        case fluctateRate24H = "fluctate_rate_24H"
    }
}
