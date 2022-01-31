//
//  CoinDetailHeader.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class CoinDetailHeader: UIView {
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()

    private let changedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private let changedRateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabels()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpBasicLayout()
    }
}

// MARK: - Facade
extension CoinDetailHeader {
    var headline: String? {
        get { headlineLabel.text }
        set { headlineLabel.text = newValue }
    }

    var changedPrice: String? {
        get { changedPriceLabel.text }
        set { changedPriceLabel.text = newValue }
    }
    var changedRate: String? {
        get { changedRateLabel.text }
        set { changedRateLabel.text = newValue }
    }

    var textColor: UIColor {
        get { headlineLabel.textColor }
        set {
            headlineLabel.textColor = newValue
            changedRateLabel.textColor = newValue
            changedPriceLabel.textColor = newValue
        }
    }
}

// MARK: - basic set up
private extension CoinDetailHeader {
    func setUpLabels() {
        let targetLabels = [headlineLabel, changedRateLabel, changedPriceLabel]

        for label in targetLabels {
            label.adjustsFontSizeToFitWidth = true
            label.adjustsFontForContentSizeCategory = true
            label.textAlignment = .justified
        }
    }

    func setUpBasicLayout() {
        let innerStackView = UIStackView(arrangedSubviews: [changedPriceLabel, changedRateLabel])
        innerStackView.axis = .horizontal
        innerStackView.distribution = .fillProportionally
        innerStackView.alignment = .fill
        innerStackView.spacing = Spacing.betweenTexts

        let outerStackView = UIStackView(arrangedSubviews: [headlineLabel, innerStackView])
        outerStackView.axis = .vertical
        outerStackView.distribution = .fill
        outerStackView.alignment = .fill
        outerStackView.spacing = .zero

        self.addSubview(outerStackView)

        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Spacing.basicVerticalInset
            ),
            outerStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Spacing.basicVerticalInset
            ),
            outerStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Spacing.basicHorizontalInset
            ),
            outerStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Spacing.basicHorizontalInset
            )
        ])
    }
}
