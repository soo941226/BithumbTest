//
//  HTTPChartAPI.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/31.
//

import Foundation

struct HTTPChartResponse: StatusRepresentable {
    var status: String?
    var message: String?
    var chartData: [ChartDatum]?

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let status = try container.decode(String.self, forKey: .status)
            self.status = status

            let chartData = try container.decode([[Something]].self, forKey: .chartData)
            self.chartData = chartData.compactMap({ somethings in
                var somethings = somethings

                guard case .int(let datetime) = somethings.removeFirst() else {
                    return nil
                }

                let remainProperties: [String] = somethings.compactMap {
                    guard case .string(let string) = $0 else { return nil }
                    return string
                }

                if remainProperties.count != 5 { return nil }

                return ChartDatum(
                    timestamp: datetime,
                    marketPrice: remainProperties[0],
                    closedPrice: remainProperties[1],
                    maxPrice: remainProperties[2],
                    minPrice: remainProperties[3],
                    tradedVolume: remainProperties[4]
                )
            })
        } catch {
            throw error
        }
    }

    enum Something: Decodable {
        case int(_ int: Int)
        case string(_ string: String)

        init(from decoder: Decoder) throws {
            if let int = try? decoder.singleValueContainer().decode(Int.self) {
                self = .int(int)
                return
            }

            if let string = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(string)
                return
            }

            throw DecodingError.dataCorrupted(.init(
                codingPath: [CodingKeys.chartData],
                debugDescription: "Server Error: Response is not vaild",
                underlyingError: APIError.unwantedResponse
            ))
        }
    }

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case chartData = "data"
    }
}

struct HTTPChartAPI: HTTPRequestable {
    private(set) var urlString = APIConfig.HTTPBaseURL + "public/candlestick/"

    let orderCurrency: Symbol
    let paymentCurreny: Symbol
    let type: ChartType

    init(orderCurrency: Symbol, paymentCurrnecy: Symbol, type: ChartType) {
        self.orderCurrency = orderCurrency
        self.paymentCurreny = paymentCurrnecy
        self.type = type
    }

    func excute(
        with completionHandler: @escaping (Result<HTTPChartResponse, Error>) -> Void
    ) {
        let urlString = urlString
        + Symbol(orderCurrency: orderCurrency, paymentCurrency: paymentCurreny)
        + type.path

        guard let url = URL(string: urlString) else { return }

        let request = URLRequest(url: url)
        HTTPManager.shared.dataTask(with: request, completionHandler: completionHandler)
    }
}
