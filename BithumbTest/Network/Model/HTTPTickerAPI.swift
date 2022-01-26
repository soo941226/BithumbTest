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

    let symbol: Symbol

    init(symbol: Symbol) {
        self.symbol = symbol
    }

    func excute(
        with completionHandler: @escaping (Result<HTTPTickerResponse, Error>) -> Void
    ) {
        let urlString = urlString + symbol
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        HTTPManager.shared.dataTask(with: request, completionHandler: completionHandler)
    }
}
