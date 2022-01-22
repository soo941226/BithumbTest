//
//  APIConfig.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import Foundation

enum APIConfig {
    static let startNetworking = Notification.Name("startNetworking")
    static let endNetworking = Notification.Name("endNetworking")
    static let WSBaseURL = "wss://pubwss.bithumb.com/pub/ws"
    static let HTTPBaseURL = "https://api.bithumb.com/"
}
