//
//  Symbol.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

typealias Symbol = String

extension Symbol {
    static let KRW = "KRW"
    static let BTC = "BTC"
    init(orderCurrency: Symbol, paymentCurrency: Symbol) {
        self = orderCurrency + "_" + paymentCurrency
    }

    var orderCurrency: Symbol? {
        guard let index = self.firstIndex(of: "_") else { return nil }

        return self.prefix(upTo: index).description
    }

    var paymentCurrency: Symbol? {
        guard let index = self.firstIndex(of: "_") else { return nil }

        return self.suffix(from: index).description
    }
}
