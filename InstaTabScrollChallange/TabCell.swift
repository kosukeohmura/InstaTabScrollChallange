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
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("left", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitle("right", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func updateHighlightedTab(_ index: Int) {
        switch index {
        case 0:
            self.leftButton.isHighlighted = true
            self.rightButton.isHighlighted = false
            
        case 1:
            self.leftButton.isHighlighted = false
            self.rightButton.isHighlighted = true
            
        default:
            break
        }
    }

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
        
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(rightButton)
        
        leftButton.addTarget(self, action: #selector(didLeftTap), for: .touchUpInside)
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
