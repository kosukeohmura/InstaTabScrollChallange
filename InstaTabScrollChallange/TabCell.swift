//
//  TabCell.swift
//  InstaTabScrollChallange
//
//  Created by Ohmura Kosuke on 2019/04/05.
//  Copyright © 2019 Ohmura Kosuke. All rights reserved.
//

import Foundation
import UIKit

protocol TabCellDelegate: class {
    func leftDidTap(in: TabCell)
    func rightDidTap(in: TabCell)
}

class TabCell: UICollectionViewCell {

    weak var delegate: TabCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: stackView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)])

        let leftButton = UIButton()
        leftButton.backgroundColor = .green
        leftButton.setTitle("left", for: .normal)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(leftButton)
        leftButton.addTarget(self, action: #selector(didLeftTap), for: .touchUpInside)

        let rightButton = UIButton()
        rightButton.backgroundColor = .purple
        rightButton.setTitle("right", for: .normal)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(rightButton)
        rightButton.addTarget(self, action: #selector(didRightTap), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didLeftTap() {
        delegate?.leftDidTap(in: self)
    }
    @objc private func didRightTap() {
        delegate?.rightDidTap(in: self)
    }
}
