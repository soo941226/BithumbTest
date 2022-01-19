//
//  HTTPTickerRequester.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import Foundation

struct HTTPTickerResponse: StatusRepresentable {
    var status: String?
    var message: String?
    var data: HTTPCoin
}

struct HTTPTickerAPI: HTTPRequestable {
    private(set) var urlString = APIConfig.HTTPBaseURL + "public/ticker/"

    let orderCurrency: OrderCurrency
    let paymentCurrency: PaymentCurrency

    init(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) {
        self.orderCurrency = orderCurrency
        self.paymentCurrency = paymentCurrency
    }

    func excute(
        with completionHandler: @escaping (Result<HTTPTickerResponse, Error>) -> Void
    ) {
        let urlString = urlString + orderCurrency.value + "_" + paymentCurrency.value
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        HTTPManager.shared.dataTask(with: request, completionHandler: completionHandler)
    }
}
