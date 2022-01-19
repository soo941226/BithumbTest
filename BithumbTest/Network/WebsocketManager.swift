//
//  WebsocketManager.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

final class WebsocketManager {
    typealias CompletionHanlder = (Result<URLSessionWebSocketTask.Message, Error>) -> Void

    static let shared = WebsocketManager()

    private let session: URLSessionWebSocketTask
    private init() {
        guard let url = URL(string: APIConfig.WSBaseURL) else {
            fatalError("invalid APIConfig.websocketBaseURL")
        }

        session = URLSession(configuration: .default).webSocketTask(with: url)
    }

    func open(with message: Data, completionHanlder: @escaping CompletionHanlder) {
        session.send(.data(message)) { error in
            if let error = error {
                completionHanlder(.failure(error))
            }
        }
        receiveMessageContinuoussly(with: completionHanlder)
        session.resume()
    }

    func close() {
        session.cancel(with: .normalClosure, reason: nil)
    }
}

private extension WebsocketManager {
    func receiveMessageContinuoussly(with completionHanlder: @escaping CompletionHanlder) {
        DispatchQueue.global().async { [weak self] in
            self?.session.receive { [weak self] result in
                switch result {
                case .success(let message):
                    completionHanlder(.success(message))
                    self?.receiveMessageContinuoussly(with: completionHanlder)
                case .failure(let error):
                    completionHanlder(.failure(error))
                }
            }
        }
    }
}
