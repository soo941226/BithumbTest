//
//  WSCoin.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

struct WSCoin: Encodable {
    let symbol: Symbol
    let tickType: TickType
    let date: String
    let hhMMss: String

    let openPrice: Double?
    let closePrice: Double?
    let minPrice: Double?
    let maxPrice: Double?
    let prevClosePrice: Double?

    let totalTradedPrice: Double?
    let totalTradedVolume: Double?
    let totalSalesVolume: Double?
    let totalPurchasedVolume: Double?

    let changedRate: Double?
    let changedPrice: Double?
    let volumePower: Double?

    enum CodingKeys: String, CodingKey, CaseIterable {
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

extension WSCoin {
    init?(origin: [String: Any]) {
        let dictionary: [String: String] = origin.compactMapValues { any in
            return any as? String
        }

        for key in CodingKeys.allCases {
            guard dictionary[key.rawValue] != nil else {
                return nil
            }

            continue
        }

        if let rawValue = dictionary[CodingKeys.tickType.rawValue],
           let tickType = TickType(rawValue: rawValue) {
            self.tickType = tickType
        } else {
            return nil
        }

        symbol = dictionary[CodingKeys.symbol.rawValue]!
        date = dictionary[CodingKeys.date.rawValue]!
        hhMMss = dictionary[CodingKeys.hhMMss.rawValue]!

        openPrice = Double(dictionary[CodingKeys.openPrice.rawValue]!)
        closePrice = Double(dictionary[CodingKeys.closePrice.rawValue]!)
        minPrice = Double(dictionary[CodingKeys.minPrice.rawValue]!)
        maxPrice = Double(dictionary[CodingKeys.maxPrice.rawValue]!)
        prevClosePrice = Double(dictionary[CodingKeys.prevClosePrice.rawValue]!)

        totalTradedPrice = Double(dictionary[CodingKeys.totalTradedPrice.rawValue]!)
        totalTradedVolume = Double(dictionary[CodingKeys.totalTradedVolume.rawValue]!)
        totalSalesVolume = Double(dictionary[CodingKeys.totalSalesVolume.rawValue]!)
        totalPurchasedVolume = Double(dictionary[CodingKeys.totalPurchasedVolume.rawValue]!)

        changedRate = Double(dictionary[CodingKeys.changedRate.rawValue]!)
        changedPrice = Double(dictionary[CodingKeys.changedPrice.rawValue]!)
        volumePower = Double(dictionary[CodingKeys.volumePower.rawValue]!)
    }
}
