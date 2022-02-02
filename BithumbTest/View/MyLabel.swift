//
//  MyLabel.swift
//  BithumbTest
//
//  Created by kjs on 2022/02/02.
//

import UIKit

final class MyLabel: UILabel {
    override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: UIEdgeInsets(
            top: Spacing.basicVerticalInset / 2,
            left: Spacing.basicHorizontalInset,
            bottom: Spacing.basicVerticalInset / 2,
            right: Spacing.basicHorizontalInset
        )))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + Spacing.basicVerticalInset * 2,
                      height: size.height + Spacing.basicHorizontalInset)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (Spacing.basicVerticalInset * 2)
        }
    }
}
