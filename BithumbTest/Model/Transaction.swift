//
//  Transaction.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

struct Transaction: Encodable {
    let type: SocketMessageType = .transaction
    let symbol: [Symbol]

    init(symbol: [Symbol]) {
        self.symbol = symbol
    }

    func message() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return String(decoding: data, as: UTF8.self)
    }
}
