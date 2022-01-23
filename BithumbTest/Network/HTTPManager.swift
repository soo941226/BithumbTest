//
//  HTTPManager.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

import Foundation

final class HTTPManager {
    static let shared = HTTPManager()

    private let session = URLSession(configuration: .default)
    private let decoder = JSONDecoder()

    func dataTask<Model: StatusRepresentable>(
        with request: URLRequest,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        NotificationCenter.default.post(name: APIConfig.startNetworking, object: nil)
        session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            if let isVaildResponse = self?.handling(response, with: completionHandler),
               isVaildResponse {

                self?.handling(data, with: completionHandler)
            }

            NotificationCenter.default.post(name: APIConfig.endNetworking, object: nil)
        }.resume()
    }
}

// MARK: - handling each type
private extension HTTPManager {
    func handling<Model>(
        _ response: URLResponse?,
        with completionHandler: (Result<Model, Error>) -> Void
    ) -> Bool {
        guard let response = response as? HTTPURLResponse else {
            completionHandler(.failure(APIError.unwantedResponse))
            return false
        }

        switch response.statusCode {
        case 200..<300:
            return true
        case 400..<500:
            completionHandler(.failure(
                APIError.clientError(code: response.statusCode, reason: response.description)
            ))
        case 500..<600:
            completionHandler(.failure(
                APIError.serverError(code: response.statusCode, reason: response.description)
            ))
        default:
            completionHandler(.failure(
                APIError.unknownError(code: response.statusCode, reason: response.description)
            ))
        }

        return false
    }

    func handling<Model: StatusRepresentable>(
        _ data: Data?,
        with completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        guard let data = data else {
            completionHandler(.failure(APIError.invalidData))
            return
        }

        do {
            let model = try decoder.decode(Model.self, from: data)

            handling(model, with: completionHandler)
        } catch {
            completionHandler(.failure(error))
        }
    }

    func handling<Model: StatusRepresentable>(
        _ model: Model,
        with completionHandler: (Result<Model, Error>) -> Void
    ) {
        guard let status = model.status else {
            completionHandler(.failure(APIError.invalidData))
            return
        }

        if status == "0000" {
            completionHandler(.success(model))
        } else if let statusCode = Int(status), let message = model.message {
            completionHandler(.failure(APIError.unknownError(
                code: statusCode,
                reason: message
            )))
        } else {
            completionHandler(.failure(APIError.unwantedResponse))
        }
    }
}
