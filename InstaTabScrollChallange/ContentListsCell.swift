//
//  ContentListsCell.swift
//  InstaTabScrollChallange
//
//  Created by Kosuke Omura on 2019/05/28.
//  Copyright © 2019 Ohmura Kosuke. All rights reserved.
//

import Foundation
import UIKit

fileprivate func makeRandomColor() -> UIColor {
    let ramdomParcentage: CGFloat = ((1..<100).map { CGFloat($0) / 100 }).randomElement()!
    return UIColor.blue.withAlphaComponent(ramdomParcentage)
}

protocol ContentListsCellDelegate: class {
    func contentListsCell(_ contentListsCell: ContentListsCell, visibleListDidChange listType: ViewController.ListType)
}

class ContentListsCell: UICollectionViewCell {
    
    weak var delegate: ContentListsCellDelegate?
    
    var mainItemCount: Int = 0 {
        didSet {
            (wholeCollectionView.cellForItem(at: .init(row: ViewController.ListType.main.index, section: 0)) as? MainContentListCell)?.mainItemCount = mainItemCount
        }
    }
    var anotherItemCount: Int = 0 {
        didSet {
            (wholeCollectionView.cellForItem(at: .init(row: ViewController.ListType.another.index, section: 0)) as? AnotherContentListCell)?.anotherItemCount = anotherItemCount
        }
    }
    
    private let wholeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    func changeVisibleList(listType: ViewController.ListType) {
        wholeCollectionView.scrollToItem(at: .init(row: listType.index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(wholeCollectionView)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: wholeCollectionView.topAnchor),
            leadingAnchor.constraint(equalTo: wholeCollectionView.leadingAnchor),
            bottomAnchor.constraint(equalTo: wholeCollectionView.bottomAnchor),
            trailingAnchor.constraint(equalTo: wholeCollectionView.trailingAnchor)])
        
        wholeCollectionView.isPagingEnabled = true
        
        wholeCollectionView.delegate = self
        wholeCollectionView.dataSource = self
        wholeCollectionView.register(MainContentListCell.self, forCellWithReuseIdentifier: MainContentListCell.self.description())
        wholeCollectionView.register(AnotherContentListCell.self, forCellWithReuseIdentifier: AnotherContentListCell.self.description())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContentListsCell: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let visibleCellIndexPath = wholeCollectionView.indexPathsForVisibleItems.last, wholeCollectionView.indexPathsForVisibleItems.count == 1 {
            delegate?.contentListsCell(self, visibleListDidChange: ViewController.ListType.allCases[visibleCellIndexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension ContentListsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewController.ListType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch ViewController.ListType.allCases[indexPath.row] {
        case .main: return collectionView.dequeueReusableCell(withReuseIdentifier: MainContentListCell.self.description(), for: indexPath)
        case .another: return collectionView.dequeueReusableCell(withReuseIdentifier: AnotherContentListCell.self.description(), for: indexPath)
        }
    }
}

class MainContentListCell: UICollectionViewCell {
    var mainItemCount: Int = 0 {
        didSet {
            wholeCollectionView.reloadData()
        }
    }
    
    private let wholeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(wholeCollectionView)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: wholeCollectionView.topAnchor),
            leadingAnchor.constraint(equalTo: wholeCollectionView.leadingAnchor),
            bottomAnchor.constraint(equalTo: wholeCollectionView.bottomAnchor),
            trailingAnchor.constraint(equalTo: wholeCollectionView.trailingAnchor)])
        
        wholeCollectionView.delegate = self
        wholeCollectionView.dataSource = self
        
        wholeCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.self.description())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainContentListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.frame.width / 3 - 8
        return CGSize(width: length, height: length)
    }
}

extension MainContentListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.self.description(), for: indexPath)
    }
}

class AnotherContentListCell: UICollectionViewCell {
    var anotherItemCount: Int = 0 {
        didSet {
            wholeCollectionView.reloadData()
        }
    }
    
    private let wholeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(wholeCollectionView)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: wholeCollectionView.topAnchor),
            leadingAnchor.constraint(equalTo: wholeCollectionView.leadingAnchor),
            bottomAnchor.constraint(equalTo: wholeCollectionView.bottomAnchor),
            trailingAnchor.constraint(equalTo: wholeCollectionView.trailingAnchor)])
        
        wholeCollectionView.delegate = self
        wholeCollectionView.dataSource = self
        
        wholeCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.self.description())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnotherContentListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.frame.width
        return CGSize(width: length, height: length)
    }
}

extension AnotherContentListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anotherItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.self.description(), for: indexPath)
    }
}
