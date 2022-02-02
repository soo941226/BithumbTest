//
//  HTTPCoin.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

final class HTTPCoin: Decodable {
    private(set) var symbol: Symbol?
    private(set) var date: String?
    private(set) var isFavorite: Bool?

    private(set) var openPrice: String?
    private(set) var closePrice: String?
    private(set) var minPrice: String?
    private(set) var maxPrice: String?
    private(set) var prevClosePrice: String?

    private(set) var currentTradedVolume: String?
    private(set) var currentTradedPrice: String?
    private(set) var dailyTradedVolume: String?
    private(set) var dailyTradedPrice: String?
    private(set) var dailyChangedPrice: String?
    private(set) var dailyChangedRate: Some?

    func updateSymbol(with symbol: Symbol) {
        self.symbol = symbol
    }

    func updateFavoirte(with isFavorite: Bool) {
        self.isFavorite = isFavorite
    }

    func updateBy(_ coin: WSCoin) {
        let placeholder = ""
        self.closePrice = coin.closePrice?.description
        self.dailyChangedRate = .string(coin.changedRate?.description ?? placeholder)
        self.currentTradedPrice = coin.currentTradedPrice
    }

    init(converFrom cdCoin: CDCoin) {
        self.symbol = cdCoin.symbol
        self.isFavorite = cdCoin.isFavorite
    }

    enum CodingKeys: String, CodingKey {
        case symbol, date, isFavorite
        case openPrice = "opening_price"
        case closePrice = "closing_price"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case prevClosePrice = "prev_closing_price"
        case currentTradedVolume = "units_traded"
        case currentTradedPrice = "acc_trade_value"
        case dailyTradedVolume = "units_traded_24H"
        case dailyTradedPrice = "acc_trade_value_24H"
        case dailyChangedPrice = "fluctate_24H"
        case dailyChangedRate = "fluctate_rate_24H"
    }

    enum Some: Decodable {
        case number(Double)
        case string(String)

        var description: String? {
            switch self {
            case .number(let number):
                return number.description
            case .string(let string):
                return string
            }
        }

        init(from decoder: Decoder) throws {
            if let number = try? decoder.singleValueContainer().decode(Double.self) {
                self = .number(number)
                return
            }

            if let string = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(string)
                return
            }

            throw DecodingError.dataCorrupted(.init(
                codingPath: [CodingKeys.dailyChangedRate],
                debugDescription: "",
                underlyingError: nil
            ))
        }
    }
}
