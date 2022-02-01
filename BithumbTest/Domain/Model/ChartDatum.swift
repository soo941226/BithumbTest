//
//  ChartDatum.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/31.
//

struct ChartDatum: Decodable {
    let timestamp: Int
    let marketPrice: String
    let closedPrice: String
    let maxPrice: String
    let minPrice: String
    let tradedVolume: String

    init(
        timestamp: Int,
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

    init(with cdDatum: CDChartDatum) {
        let placeHolder = ""
        self.timestamp = Int(cdDatum.timestamp)
        self.marketPrice = cdDatum.marketPrice ?? placeHolder
        self.closedPrice = cdDatum.closedPrice ?? placeHolder
        self.maxPrice = cdDatum.maxPrice ?? placeHolder
        self.minPrice = cdDatum.minPrice ?? placeHolder
        self.tradedVolume = cdDatum.tradedVolume ?? placeHolder
    }
}
