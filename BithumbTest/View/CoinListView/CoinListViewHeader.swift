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
    private lazy var sortingButtons = [
        symbolSortingButton, currentPriceSortingButton,
        changedRateSortingButton, tradedPriceSortingButton
    ]

    private let containerStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp(stackViews: containerStackView, firstStackView, secondStackView)
        setUpSortingButtons()
        setUpSubviews()
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
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

    func setUpSortingButtons() {
        let notificatinoIdentiifer = Notification.Name(CoinListViewHeader.identifier)

        for (index, button) in sortingButtons.enumerated() {
            button.textColor = .black
            button.font = .preferredFont(forTextStyle: .body)
            button.textAlignment = .justified
            button.adjustsFontSizeToFitWidth = true
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.setUp { [weak self, weak button] in
                self?.sortingButtons.forEach { eachButton in
                    if button == eachButton {
                        button?.currentState.next()
                        NotificationCenter.default.post(
                            name: notificatinoIdentiifer,
                            object: nil,
                            userInfo: [
                                "key": index,
                                "direction": button?.currentState.rawValue ?? .zero
                            ]
                        )
                    } else {
                        eachButton.currentState = .none
                    }
                }
            }

            if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
                button.layer.borderWidth = 1
            } else {
                button.layer.borderWidth = 0
            }
        }

        sortingButtons.last?.currentState = .descending
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
