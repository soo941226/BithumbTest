//
//  HTTPCoin.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

import Foundation

class HTTPCoin: Decodable {
    private(set) var symbol: Symbol?
    private(set) var date: String?
    private(set) var isFavorite: Bool?

    private(set) var openPrice: String?
    private(set) var closePrice: String?
    private(set) var minPrice: String?
    private(set) var maxPrice: String?
    private(set) var prevClosePrice: String?

    private(set) var currentTradedVolume: String?
    private(set) var currentTradedPrice: String?
    private(set) var dailyTradedVolume: String?
    private(set) var dailyTradedPrice: String?
    private(set) var dailyChangedPrice: String?
    private(set) var dailyChangedRate: String?

    func updateSymbol(with symbol: Symbol) {
        self.symbol = symbol
    }

    func updateFavoirte(with isFavorite: Bool) {
        self.isFavorite = isFavorite
    }

    func updateBy(_ coin: WSCoin) {
        self.closePrice = coin.closePrice?.description
        self.dailyChangedRate = coin.changedRate?.description
        self.currentTradedPrice = coin.currentTradedPrice
    }

    enum CodingKeys: String, CodingKey {
        case symbol, date, isFavorite
        case openPrice = "opening_price"
        case closePrice = "closing_price"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case prevClosePrice = "prev_closing_price"
        case currentTradedVolume = "units_traded"
        case currentTradedPrice = "acc_trade_value"
        case dailyTradedVolume = "units_traded_24H"
        case dailyTradedPrice = "acc_trade_value_24H"
        case dailyChangedPrice = "fluctate_24H"
        case dailyChangedRate = "fluctate_rate_24H"
    }
}
