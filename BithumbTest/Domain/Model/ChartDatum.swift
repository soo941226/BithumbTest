//
//  ChartDatum.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/31.
//

import Foundation

final class ChartDatum: Decodable {
    let timestamp: String
    let marketPrice: String
    let closedPrice: String
    let maxPrice: String
    let minPrice: String
    let tradedVolume: String

    init(
        timestamp: String,
        marketPrice: String,
        closedPrice: String,
        maxPrice: String,
        minPrice: String,
        tradedVolume: String
    ) {
        self.timestamp = timestamp
        self.marketPrice = marketPrice
        self.closedPrice = closedPrice
        self.maxPrice = maxPrice
        self.minPrice = minPrice
        self.tradedVolume = tradedVolume
    }
}
