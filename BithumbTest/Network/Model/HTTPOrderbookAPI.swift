//
//  HTTPOrderbookAPI.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import Foundation

struct HTTPOrderbookAPIResponse: StatusRepresentable {
    var status: String?
    var message: String?
    var data: HTTPOrderbook?
}

struct HTTPOrderbookAPI: HTTPRequestable {
    private(set) var urlString = APIConfig.HTTPBaseURL + "public/orderbook/"

    let orderCurrency: Symbol
    let paymentCurrency: Symbol

    init(with orderCurrency: Symbol, and paymentCurrency: Symbol) {
        self.orderCurrency = orderCurrency
        self.paymentCurrency = paymentCurrency
    }

    func excute(
        with completionHandler: @escaping (Result<HTTPOrderbookAPIResponse, Error>) -> Void
    ) {
        let urlPath = Symbol(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
        let urlString = urlString + urlPath

        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        HTTPManager.shared.dataTask(with: request, completionHandler: completionHandler)
    }
}
