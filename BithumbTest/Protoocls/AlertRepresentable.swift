//
//  AlertRepresentable.swift
//  BithumbTest
//
//  Created by kjs on 2022/02/02.
//

import UIKit

protocol AlertRepresentable where Self: UIViewController {
    func showAlert(with error: Error)
}

extension AlertRepresentable {
    func showAlert(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self?.present(alertController, animated: false)
        }
    }
}
