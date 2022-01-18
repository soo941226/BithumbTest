//
//  APIError.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

enum APIError: Error {
    case unwantedResponse
    case invalidData
    case clientError(code: Int, reason: String)
    case serverError(code: Int, reason: String)
    case unknownError(code: Int, reason: String)

    var description: String {
        switch self {
        case .invalidData:
            return "서버로부터 유효안 데이터가 오지 않았습니다. 해당 에러가 반복되면 고객센터에 문의바랍니다."
        case .clientError(_, let code):
            return "클라이언트 에러: \(code) 해당 에러가 반복되면 고객센터에 문의바랍니다."
        case .serverError(_, let code):
            return "서버 에러: \(code) 해당 에러가 반복되면 고객센터에 문의바랍니다."
        case .unknownError(_, let code):
            return "알 수 없는 에러가 발생했습니다: \(code) 해당 에러가 반복되면 고객센터에 문의바랍니다."
        default:
            return "something wrong, but not critical"
        }
    }
}
