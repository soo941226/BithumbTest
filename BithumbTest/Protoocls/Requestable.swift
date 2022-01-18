//
//  Requestable.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

protocol RequestHandleable: Encodable {
    associatedtype ResponseType

    func excute(with: @escaping (Result<ResponseType, Error>) -> Void)

    var message: Data? { get }
}

extension RequestHandleable {
    var message: Data? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return data
    }
}

protocol ResponseHandleable {
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

extension ResponseHandleable {
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

typealias Requestable = RequestHandleable & ResponseHandleable
