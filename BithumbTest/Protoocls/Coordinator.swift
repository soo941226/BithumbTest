//
//  Coordinator.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/25.
//

import UIKit

@objc protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }

    init(navigationController: UINavigationController)

    func start()
    @objc optional func next()
}
