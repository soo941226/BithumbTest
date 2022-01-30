//
//  HTTPTickerAllAPI.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

import Foundation

struct HTTPTickerAllResponse: StatusRepresentable {
    var status: String?
    var message: String?
    var dictionary: [String: Some]

    enum CodingKeys: String, CodingKey {
        case status, message
        case dictionary = "data"
    }

    enum Some: Decodable {
        case coin(HTTPCoin)
        case string(String)

        init(from decoder: Decoder) throws {
            if let coin = try? decoder.singleValueContainer().decode(HTTPCoin.self) {
                self = .coin(coin)
                return
            }

            if let string = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(string)
                return
            }

            throw DecodingError.dataCorrupted(.init(
                codingPath: [CodingKeys.dictionary],
                debugDescription: "Server Error: Response is not vaild",
                underlyingError: APIError.unwantedResponse
            ))
        }
    }
}

struct HTTPTickerAllAPI: HTTPRequestable {
    private(set) var urlString = APIConfig.HTTPBaseURL + "public/ticker/ALL_"

    let paymentCurrency: Symbol

    init(with paymentCurrency: Symbol) {
        self.paymentCurrency = paymentCurrency
    }

    func excute(
        with completionHandler: @escaping (Result<HTTPTickerAllResponse, Error>) -> Void
    ) {
        guard let url = URL(string: urlString + paymentCurrency) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        HTTPManager.shared.dataTask(with: request, completionHandler: completionHandler)
    }
}
