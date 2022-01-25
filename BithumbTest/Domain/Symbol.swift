//
//  Symbol.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

typealias Symbol = String

extension Symbol {
    init(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) {
        self = orderCurrency.value + "_" + paymentCurrency.value
    }

    init(orderCurrency: Symbol, paymentCurrency: PaymentCurrency) {
        self = orderCurrency + "_" + paymentCurrency.value
    }

    var orderCurrency: Symbol? {
        guard let index = self.firstIndex(of: "_") else { return nil }

        return self.prefix(upTo: index).description
    }
}
