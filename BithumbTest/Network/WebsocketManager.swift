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
    private init(urlString: String) {
        guard let url = URL(string: urlString) else {
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
    convenience init() {
        self.init(urlString: APIConfig.WSBaseURL)
    }

    func receiveMessageContinuoussly(with completionHanlder: @escaping CompletionHanlder) {
        session.receive { [weak self] result in
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
