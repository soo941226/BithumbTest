//
//  WSTransactionAPI.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

struct WSTransactionAPI: WSRequestable {
    typealias CompletionHandler = (Result<[WSTransactionHistory], Error>) -> Void

    let type = SocketMessageType.transaction
    let symbols: [Symbol]
    
    init(symbols: [Symbol]) {
        self.symbols = symbols
    }
    
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
               type != SocketMessageType.transaction.rawValue {
                completionHandler(.failure(APIError.unwantedResponse))
                return
            }
            guard let content = json?["content"] as? [String: Any],
                  let list = content["list"] as? [[String: Any]] else {
                      completionHandler(.failure(APIError.invalidData))
                      return
                  }
            let histories = list.compactMap { (dictionary: [String: Any]) in
                return WSTransactionHistory(origin: dictionary)
            }

            completionHandler(.success(histories))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
