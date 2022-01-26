//
//  DataManager.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/25.
//

import Foundation

@objc protocol DataManager: AnyObject {
    func stopManaging()
    func restartManaging()
    @objc optional func showDetail(with: IndexPath)
}
