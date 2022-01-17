//
//  TickType.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

enum TickType: String, Encodable, CustomStringConvertible {
    case halfHour = "30M"
    case oneHour = "1H"
    case twelveHour = "12H"
    case twentyFourHour = "24H"
    case MID

    var description: String {
        return self.rawValue
    }
}
