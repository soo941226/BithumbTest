//
//  Requestable.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

protocol Requestable: Encodable {
    associatedtype ResponseType

    func excute(with: @escaping (Result<ResponseType, Error>) -> Void)

    var message: String? { get }
}

extension Requestable {
    var message: String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return String(decoding: data, as: UTF8.self)
    }
}
