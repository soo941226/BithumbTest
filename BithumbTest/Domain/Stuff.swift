//
//  Stuff.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import Foundation

struct Stuff: Decodable {
    let price: Double
    var quantity: Double

    enum CodingKeys: String, CodingKey {
        case price, quantity
    }
}

extension Stuff {
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let quantity = try container.decode(String.self, forKey: .quantity)
            let price = try container.decode(String.self, forKey: .price)

            if let quantity = Double(quantity),
               let price = Double(price) {
                self.quantity = quantity
                self.price = price
            } else {
                throw DecodingError.valueNotFound(Stuff.self, .init(
                    codingPath: [CodingKeys.price, CodingKeys.quantity],
                    debugDescription: "Data is not vaild",
                    underlyingError: APIError.invalidData)
                )
            }
        } catch {
            throw error
        }
    }
}
