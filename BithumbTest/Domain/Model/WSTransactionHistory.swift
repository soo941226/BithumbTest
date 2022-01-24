//
//  WSTransactionHistory.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

class WSTransactionHistory {
    let symbol: Symbol?
    let tradeType: TradeType?
    let capturedPrice: Double?
    let capturedQuantity: Double?
    let totalPrice: Double?
    let capturedDate: String?
    let direction: Direction?

    init?(origin: [String: Any]) {
        let dictionary: [String: String] = origin.compactMapValues { any in
            return any as? String
        }

        for key in CodingKeys.allCases {
            guard dictionary[key.rawValue] != nil else {
                return nil
            }
        }

        if let tradeRawValue = dictionary[CodingKeys.tradeType.rawValue] {
            self.tradeType = TradeType(rawValue: tradeRawValue)
        } else {
            return nil
        }

        if let directionRawValue = dictionary[CodingKeys.direction.rawValue] {
            self.direction = Direction(rawValue: directionRawValue)
        } else {
            return nil
        }

        symbol = dictionary[CodingKeys.symbol.rawValue]
        capturedPrice = Double(dictionary[CodingKeys.capturedPrice.rawValue]!)
        capturedQuantity = Double(dictionary[CodingKeys.capturedQuantity.rawValue]!)
        totalPrice = Double(dictionary[CodingKeys.totalPrice.rawValue]!)
        capturedDate = dictionary[CodingKeys.capturedDate.rawValue]
    }

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
