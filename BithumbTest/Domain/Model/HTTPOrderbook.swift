//
//  HTTPOrderbook.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import Foundation

class HTTPOrderbook: Decodable {
    let timestamp: String
    let orderCurrency: String
    let paymentCurrency: String
    let bids: [Stuff]
    let asks: [Stuff]

    enum CodingKeys: String, CodingKey {
        case timestamp
        case orderCurrency = "order_currency"
        case paymentCurrency = "payment_currency"
        case bids, asks
    }
}
