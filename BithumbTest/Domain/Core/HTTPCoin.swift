//
//  HTTPCoin.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

import Foundation

struct HTTPCoin: Decodable {
    private(set) var symbol: Symbol?
    let openingPrice: String?
    let closingPrice: String?
    let minPrice: String?
    let maxPrice: String?
    let currentTradedVolume: String?
    let currentTradedPrice: String?
    let prevClosingPrice: String?
    let dailyTradedVolume: String?
    let dailyTradedPrice: String?
    let dailyChangedPrice: String?
    let dailyChangedRate: String?
    var date: String?

    mutating func updateSymbol(with symbol: Symbol) {
        self.symbol = symbol
    }

    enum CodingKeys: String, CodingKey {
        case symbol, date
        case openingPrice = "opening_price"
        case closingPrice = "closing_price"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case currentTradedVolume = "units_traded"
        case currentTradedPrice = "acc_trade_value"
        case prevClosingPrice = "prev_closing_price"
        case dailyTradedVolume = "units_traded_24H"
        case dailyTradedPrice = "acc_trade_value_24H"
        case dailyChangedPrice = "fluctate_24H"
        case dailyChangedRate = "fluctate_rate_24H"
    }
}
