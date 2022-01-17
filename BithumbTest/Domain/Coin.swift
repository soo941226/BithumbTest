//
//  Coin.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

struct Coin: Encodable {
    let symbol: String?
    let tickType: String?
    let date: String?
    let hhMMss: String?

    let openPrice: String?
    let closePrice: String?
    let minPrice: String?
    let maxPrice: String?
    let prevClosePrice: String?

    let totalTradedPrice: String?
    let totalTradedVolume: String?
    let totalSalesVolume: String?
    let totalPurchasedVolume: String?

    let changedRate: String?
    let changedPrice: String?
    let volumePower: String?

    enum CodingKeys: String, CodingKey {
        case symbol, tickType, date, openPrice, closePrice, prevClosePrice, volumePower
        case hhMMss = "time"
        case minPrice = "lowPrice"
        case maxPrice = "highPrice"
        case totalTradedPrice = "value"
        case totalTradedVolume = "volume"
        case totalSalesVolume = "sellVolume"
        case totalPurchasedVolume = "buyVolume"
        case changedRate = "chgRate"
        case changedPrice = "chgAmt"
    }
}
