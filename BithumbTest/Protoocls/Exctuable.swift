//
//  Exctuable.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

import Foundation

protocol Excutable {
    associatedtype ResponseType

    func excute(with: @escaping (Result<ResponseType, Error>) -> Void)
}
