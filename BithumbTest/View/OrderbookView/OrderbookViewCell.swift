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
        setUpSubviews()

    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()

        layoutContents()
    }
}

// MARK: - Facade
extension OrderbookViewCell {
    func setUp(visualState: StackViewStyle) {
        self.visualState = visualState
    }

    func configure(with stuff: Stuff?) {
        guard let stuff = stuff else { return }
        priceLabel.text = stuff.price.description
        quantityLabel.text = String(format: "%.3f", stuff.quantity)
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
        innerStackView.alignment = .leading
    }

    func layoutContents() {
        contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }

        if visualState == .merged {
            let outerStackView = UIStackView(arrangedSubviews: [innerStackView, quantityLabel])
            outerStackView.axis = .horizontal
            outerStackView.distribution = .equalCentering
            outerStackView.alignment = .fill
            outerStackView.spacing = Spacing.betweenTexts

            innerStackView.setContentCompressionResistancePriority(.required, for: .horizontal)

            contentView.addSubview(outerStackView)

            outerStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                outerStackView.topAnchor.constraint(
                    equalTo: contentView.topAnchor,
                    constant: Spacing.verticalInsetOfCell
                ),
                outerStackView.bottomAnchor.constraint(
                    equalTo: contentView.bottomAnchor,
                    constant: -Spacing.verticalInsetOfCell
                ),
                outerStackView.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: Spacing.horizontalInsetOfCell
                ),
                outerStackView.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -Spacing.horizontalInsetOfCell
                )
            ])
        }
    }
}
