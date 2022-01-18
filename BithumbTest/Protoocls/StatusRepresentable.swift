//
//  StatusRepresentable.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

protocol StatusRepresentable: Decodable {
    var status: String? { get set }
    var message: String? { get set }
}
