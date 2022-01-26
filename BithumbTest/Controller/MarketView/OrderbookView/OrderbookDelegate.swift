//
//  OrderbookDelegate.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class OrderbookDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == .zero {
            cell.backgroundColor = .blueDecreased
        } else {
            cell.backgroundColor = .redIncreased
        }
    }
}
