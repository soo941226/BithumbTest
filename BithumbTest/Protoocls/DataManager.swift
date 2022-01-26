//
//  DataManager.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/25.
//

import Foundation

protocol DataManager: AnyObject {
    func stopManaging()
    func restartManaging()
    func showDetail(with: IndexPath)
}
