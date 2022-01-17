//
//  PaymentCurrency.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

enum PaymentCurrency: String {
    case BTC
    case KRW

    var value: String {
        return self.rawValue
    }
}
