//
//  OrderType.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/29.
//

enum OrderType: String, CaseIterable {
    case ask
    case bid

    var section: Int {
        switch self {
        case .ask:
            return 0
        case .bid:
            return 1
        }
    }
}
