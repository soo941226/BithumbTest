//
//  SceneDelegate.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let indicator = UIActivityIndicatorView(style: .medium)
    private let rootCoordinator = RootCoordinator()
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        setUpWindow(with: windowScene)
        rootCoordinator.start()
        setUpIndicator()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNetworkingIsStart), name: APIConfig.startNetworking, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNetwokringIsEnd), name: APIConfig.endNetworking, object: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - set up window
private extension SceneDelegate {
    func setUpWindow(with windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootCoordinator.navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - about Indicator
private extension SceneDelegate {
    func setUpIndicator() {
        guard let view = window?.rootViewController?.view else { return }
        view.addSubview(indicator)

        indicator.backgroundColor = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: view.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc func receiveNetworkingIsStart() {
        DispatchQueue.main.async { [weak self] in
            self?.indicator.startAnimating()
        }
    }

    @objc func receiveNetwokringIsEnd() {
        DispatchQueue.main.async { [weak self] in
            self?.indicator.stopAnimating()
        }
    }
}
