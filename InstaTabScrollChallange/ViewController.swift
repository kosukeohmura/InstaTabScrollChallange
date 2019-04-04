//
//  ViewController.swift
//  InstaTabScrollChallange
//
//  Created by Ohmura Kosuke on 2019/04/05.
//  Copyright © 2019 Ohmura Kosuke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Content: Equatable {
        case main(itemCount: Int)
        case another(itemCount: Int)
    }

    var content: Content {
        willSet {
            if content != newValue {
                collectionView.reloadData()
            }
        }
    }

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var mainItemCount = 50
    var anotherItemCount = 3

    init() {
        content = .main(itemCount: 50)
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

        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: "header")
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: "tab")
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: "content")
        collectionView.register(AnotherContentCell.self, forCellWithReuseIdentifier: "anotherContent")
    }

    func makeRandomColor() -> UIColor {
        let ramdomParcentage: CGFloat = ((1..<100).map { CGFloat($0) / 100 }).randomElement()!
        return UIColor.blue.withAlphaComponent(ramdomParcentage)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch content {
        case .main(let itemCount): return 2 + itemCount
        case .another(let itemCount): return 2 + itemCount
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath)
            cell.backgroundColor = .lightGray
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tab", for: indexPath) as! TabCell
            cell.delegate = self
            cell.backgroundColor = .white
            return cell
        default:
            let identifier: String = {
                switch content {
                case .main: return "content"
                case .another: return "anotherContent"
                }
            }()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            cell.backgroundColor = makeRandomColor()
            return cell
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
            switch content {
            case .main:
                let length = collectionView.frame.width / 3 - 8
                return CGSize(width: length, height: length)
            case .another:
                let length = collectionView.frame.width
                return CGSize(width: length, height: length)
            }
        }
    }
}

extension ViewController: TabCellDelegate {
    func leftDidTap(in: TabCell) {
        content = .main(itemCount: mainItemCount)
    }
    func rightDidTap(in: TabCell) {
        content = .another(itemCount: anotherItemCount)
    }
}
