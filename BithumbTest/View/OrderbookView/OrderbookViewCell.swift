//
//  OrderbookViewCell.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class OrderbookViewCell: UITableViewCell {
    static let identifier = #fileID
    private let innerStackView = UIStackView()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()

    private var visualState = StackViewStyle.merged

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLabels()
    }

}

// MARK: - Facade
extension OrderbookViewCell {
    func setUp(visualState: StackViewStyle) {
        self.visualState = visualState
    }

    func configure(with stuff: Stuff) {
        priceLabel.text = stuff.price
        quantityLabel.text = stuff.quantity
    }
}

// MARK: - basic set up
private extension OrderbookViewCell {
    func setUpLabels() {
        let targetLabel = [priceLabel, rateLabel, quantityLabel]

        for label in targetLabel {
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .justified
        }
    }

    func setUpSubviews() {
        innerStackView.addArrangedSubview(priceLabel)
        innerStackView.addArrangedSubview(rateLabel)
        innerStackView.axis = .vertical
        innerStackView.distribution = .equalSpacing
        innerStackView.spacing = .zero
        innerStackView.alignment = .center

        contentView.addSubview(innerStackView)
        contentView.addSubview(quantityLabel)
    }

    func layoutContents() {
        innerStackView.constraints.forEach { constraint in
            innerStackView.removeConstraint(constraint)
        }

        if visualState == .merged {
            NSLayoutConstraint.activate([

            ])
        }
    }
}
