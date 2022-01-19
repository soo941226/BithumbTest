//
//  TransactionRequester+Extension.swift
//  BithumbTestTests
//
//  Created by kjs on 2022/01/17.
//

import Foundation
@testable import BithumbTest

extension WSTransactionAPI {
    var message: String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return String(decoding: data, as: UTF8.self)
    }
}
