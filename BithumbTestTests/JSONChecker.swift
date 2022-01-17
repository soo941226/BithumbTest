//
//  JSONChecker.swift
//  BithumbTestTests
//
//  Created by kjs on 2022/01/17.
//

import Foundation

struct JSONChecker {
    func excute(with string: String) -> Bool {
        do {
            let _ = try JSONSerialization.data(withJSONObject: string, options: .fragmentsAllowed)
            return true
        } catch {
            return false
        }
    }
}
