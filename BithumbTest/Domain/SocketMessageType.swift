//
//  SocketMessageType.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

enum SocketMessageType: String, CustomStringConvertible, Encodable {
    case ticker
    case orderbook
    case transaction

    var description: String {
        return self.rawValue
    }
}
