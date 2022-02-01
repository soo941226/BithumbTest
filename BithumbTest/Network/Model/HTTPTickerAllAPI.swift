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
    typealias ResultType = Result<HTTPTickerAllResponse, Error>
    private(set) var urlString = APIConfig.HTTPBaseURL + "public/ticker/ALL_"

    let paymentCurrency: Symbol

    init(with paymentCurrency: Symbol) {
        self.paymentCurrency = paymentCurrency
    }

    func excute(
        with completionHandler: @escaping (ResultType) -> Void
    ) {
        guard let url = URL(string: urlString + paymentCurrency) else { return }
        let request = URLRequest(url: url)

        HTTPManager.shared.dataTask(with: request) { (result: ResultType) in
            switch result {
            case .success(let response):
                let cdCoins: [CDCoin]? = CDManager.shared.retrieve()
                var response = response

                for key in response.dictionary.keys {
                    guard let value = response.dictionary[key] else { continue }
                    guard case .coin(let coin) = value else { continue }

                    let symbol = Symbol(orderCurrency: key, paymentCurrency: paymentCurrency)
                    coin.updateSymbol(with: symbol)

                    if let cdCoin = cdCoins?.filter({ $0.symbol == symbol }).first {
                        coin.updateFavoirte(with: cdCoin.isFavorite)
                    }

                    response.dictionary[key] = .coin(coin)
                }

                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
