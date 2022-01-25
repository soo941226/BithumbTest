//
//  SortDirection.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/21.
//

enum SortDirection: Int {
    case none
    case ascending
    case descending

    mutating func next() {
        let rawValue = self.rawValue + 1
        guard let next = SortDirection(rawValue: rawValue) else {
            self = .none
            return
        }

        self = next
    }
}
