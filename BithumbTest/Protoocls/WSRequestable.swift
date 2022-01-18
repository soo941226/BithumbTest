//
//  WSRequestable.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

protocol WSRequestHandleable: Excutable {
    var message: Data? { get }
}

extension WSRequestHandleable {
    var message: Data? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return data
    }
}

protocol WSResponseHandleable {
    associatedtype ResponseType

    func handle(
        _ string: String,
        with completionHandler: @escaping (Result<ResponseType, Error>) -> Void
    )

    func handle(
        _ data: Data,
        with completionHandler: @escaping (Result<ResponseType, Error>) -> Void
    )
}

extension WSResponseHandleable {
    func handle(
        _ string: String,
        with completionHandler: @escaping (Result<ResponseType, Error>) -> Void
    ) {
        guard let data = string.data(using: .utf8) else {
            completionHandler(.failure(APIError.invalidData))
            return
        }
        handle(data, with: completionHandler)
    }
}

typealias WSRequestable = WSRequestHandleable & WSResponseHandleable
