//
//  TransactionHistory.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

struct TransactionHistory {
    let symbol: Symbol
    let tradeType: TradeType
    let capturedPrice: Double
    let capturedQuantity: Double
    let totalPrice: Double
    let capturedDate: String
    let direction: Direction

    enum TradeType: String {
        case sell = "1"
        case buy = "2"
    }

    enum Direction: String {
        case up = "up"
        case down = "dn"
    }

    enum CodingKeys: String, CaseIterable {
        case symbol
        case tradeType = "buySellGb"
        case capturedPrice = "contPrice"
        case capturedQuantity = "contQty"
        case totalPrice = "contAmt"
        case capturedDate = "contDtm"
        case direction = "updn"
    }
}

extension TransactionHistory {
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

        if let tradeRawValue = dictionary[CodingKeys.tradeType.rawValue],
           let tradeType = TradeType(rawValue: tradeRawValue) {
            self.tradeType = tradeType
        } else {
            return nil
        }

        if let directionRawValue = dictionary[CodingKeys.direction.rawValue],
           let direction = Direction(rawValue: directionRawValue) {
            self.direction = direction
        } else {
            return nil
        }

        symbol = dictionary[CodingKeys.symbol.rawValue]!
        capturedPrice = Double(dictionary[CodingKeys.capturedPrice.rawValue]!) ?? 0
        capturedQuantity = Double(dictionary[CodingKeys.capturedQuantity.rawValue]!) ?? 0
        totalPrice = Double(dictionary[CodingKeys.totalPrice.rawValue]!) ?? 0
        capturedDate = dictionary[CodingKeys.capturedDate.rawValue]!
    }
}
