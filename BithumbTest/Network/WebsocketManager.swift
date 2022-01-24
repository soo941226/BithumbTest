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

    private let session: URLSession
    private let baseURL: URL
    private var websocketTask: URLSessionWebSocketTask
    private init() {
        guard let url = URL(string: APIConfig.WSBaseURL) else {
            fatalError("invalid APIConfig.websocketBaseURL")
        }

        session = URLSession(configuration: .default)
        baseURL = url
        websocketTask = session.webSocketTask(with: baseURL)
    }

    func open(with message: Data, completionHanlder: @escaping CompletionHanlder) {
        websocketTask.cancel()
        websocketTask = session.webSocketTask(with: baseURL)
        websocketTask.resume()
        websocketTask.send(.data(message)) { error in
            if let error = error {
                completionHanlder(.failure(error))
            }
        }
        receiveMessageContinuoussly(with: completionHanlder)
    }

    func close() {
        websocketTask.cancel()
    }
}

private extension WebsocketManager {
    func receiveMessageContinuoussly(with completionHanlder: @escaping CompletionHanlder) {
        DispatchQueue.global().async { [weak self] in
            self?.websocketTask.receive { [weak self] result in
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
