//
//  ViewController.swift
//  InstaTabScrollChallange
//
//  Created by Ohmura Kosuke on 2019/04/05.
//  Copyright © 2019 Ohmura Kosuke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum ListType: Int, CaseIterable {
        case main
        case another
        
        var index: Int { return ListType.allCases.firstIndex(of: self)! }
    }

    var visibleListType: ListType = .main {
        willSet {
            guard visibleListType != newValue else { return }
            
            if let tabCell = (collectionView.visibleCells.compactMap { $0 as? TabCell }).first {
                tabCell.updateHighlightedTab(newValue.index)
            }
            if let listsCell = (collectionView.visibleCells.compactMap { $0 as? ContentListsCell }).first {
                listsCell.changeVisibleList(listType: newValue)
            }
        }
    }

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var mainItemCount = 50
    var anotherItemCount = 3

    init() {
        super.init(nibName: nil, bundle: Bundle(for: ViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "superinsta"

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)])

        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.self.description())
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: TabCell.self.description())
        collectionView.register(ContentListsCell.self, forCellWithReuseIdentifier: ContentListsCell.self.description())
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.self.description(), for: indexPath)
            cell.backgroundColor = .lightGray
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCell.self.description(), for: indexPath) as! TabCell
            cell.delegate = self
            cell.backgroundColor = .white
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentListsCell.self.description(), for: indexPath) as! ContentListsCell
            cell.delegate = self
            cell.mainItemCount = mainItemCount
            cell.anotherItemCount = anotherItemCount
            return cell
            
        default:
            fatalError()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 100)
        case 1:
            return CGSize(width: collectionView.frame.width, height: 30)
        default:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width - 30)
        }
    }
}

extension ViewController: TabCellDelegate {
    func leftDidTap(in: TabCell) {
        visibleListType = .main
    }
    func rightDidTap(in: TabCell) {
        visibleListType = .another
    }
}

extension ViewController: ContentListsCellDelegate {
    func contentListsCell(_ contentListsCell: ContentListsCell, visibleListDidChange listType: ViewController.ListType) {
        visibleListType = listType
    }
}
