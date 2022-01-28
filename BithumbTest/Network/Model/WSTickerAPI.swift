//
//  WSTickerRequester.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

struct WSTickerAPI: WSRequestable {
    typealias CompletionHandler = (Result<WSCoin, Error>) -> Void

    let type = SocketMessageType.ticker
    let symbols: [Symbol]
    let tickTypes: [TickType]

    func excute(with completionHandler: @escaping CompletionHandler) {
        guard let message = message else { return }

        WebsocketManager.shared.open(with: message) { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let string):
                    handle(string, with: completionHandler)
                default:
                    completionHandler(.failure(APIError.invalidData))
                }

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func handle(_ data: Data, with completionHandler: @escaping CompletionHandler) {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

            if let type = json?["type"] as? String,
               type != SocketMessageType.ticker.rawValue {
                completionHandler(.failure(APIError.unwantedResponse))
                return
            }
            
            guard let content = json?["content"] as? [String: Any],
                  let coin = WSCoin(origin: content) else {
                      completionHandler(.failure(APIError.invalidData))
                      return
                  }

            completionHandler(.success(coin))

        } catch {
            completionHandler(.failure(error))
        }
    }

    static func cancel() {
        WebsocketManager.shared.close()
    }
}
