//
//  APIError.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

enum APIError: Error {
    case unwantedResponse
    case invalidData
    case cilentError(code: Int, reason: String)

    var description: String {
        switch self {
        case .invalidData:
            return "arrived invalid data"
        case .cilentError(let code, let reason):
            return "Client Error(\(code)): \(reason)"
        default:
            return "something wrong, but not critical"
        }
    }
}
