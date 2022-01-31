//
//  ChartType.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/31.
//

enum ChartType {
    case oneMinute
    case tenMinute
    case halfHour
    case oneHour
    case day

    var path: String {
        switch self {
        case .oneMinute:
            return "/1m"
        case .tenMinute:
            return "/10m"
        case .halfHour:
            return "/30m"
        case .oneHour:
            return "/1h"
        case .day:
            return "/24h"
        }
    }
}
