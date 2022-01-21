//
//  CoinListViewHeader.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewHeader: UITableViewHeaderFooterView {
    static let identifier = #fileID

    private let symbolSortingButton: CoinListViewSortButton = {
        let button = CoinListViewSortButton()
        button.text = "가상자산명"
        return button
    }()
    private let currentPriceSortingButton: CoinListViewSortButton = {
        let button = CoinListViewSortButton()
        button.text = "현재가"
        return button
    }()
    private let changedRateSortingButton: CoinListViewSortButton = {
        let button = CoinListViewSortButton()
        button.text = "변동률"
        return button
    }()
    private let tradedPriceSortingButton: CoinListViewSortButton = {
        let button = CoinListViewSortButton()
        button.text = "거래금액"
        return button
    }()

    private let containerStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp(stackViews: containerStackView, firstStackView, secondStackView)
        setUp(
            buttons: symbolSortingButton,
            currentPriceSortingButton,
            changedRateSortingButton,
            tradedPriceSortingButton
        )
        setUpSubviews()
    }

    override func layoutMarginsDidChange() {
        layoutContents()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutContents()
    }
}

// MARK: - layout contents
private extension CoinListViewHeader {
    func setUp(stackViews: UIStackView...) {
        for stackView in stackViews {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            stackView.spacing = .zero
        }
    }

    func setUp(buttons: CoinListViewSortButton...) {
        for button in buttons {
            button.textColor = .black
            button.font = .preferredFont(forTextStyle: .body)
            button.textAlignment = .justified
            button.adjustsFontSizeToFitWidth = true
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.setUp { [weak button] in
                button?.currentState.next()
            }

            if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
                button.layer.borderWidth = 1
            } else {
                button.layer.borderWidth = 0
            }
        }
    }

    func setUpSubviews() {
        firstStackView.addArrangedSubview(symbolSortingButton)
        firstStackView.addArrangedSubview(currentPriceSortingButton)

        secondStackView.addArrangedSubview(changedRateSortingButton)
        secondStackView.addArrangedSubview(tradedPriceSortingButton)

        containerStackView.addArrangedSubview(firstStackView)
        containerStackView.addArrangedSubview(secondStackView)
        contentView.addSubview(containerStackView)

        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func layoutContents() {
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            containerStackView.axis = .vertical
        } else {
            containerStackView.axis = .horizontal
        }
    }
}
