//
//  HTTPRequestable.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/18.
//

protocol HTTPRequestable: Excutable {
    var urlString: String { get }
}
