//
//  CoinListViewSortButton.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/20.
//

import UIKit

//TODO: - 좌측에 라벨, 우측의 상하로 이미지뷰 두고 상태관리하는 버튼, 상태에 따라 escaping closure 실행하도록 구현하기

final class CoinListViewSortButton: UIView {

    private let label = UILabel()
    private let imageView = (
        up: UIImageView(image: UIImage(systemName: "arrowtriangle.up.fill")),
        down: UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
    )

}

// MARK: - managing status
private extension CoinListViewSortButton {

}
