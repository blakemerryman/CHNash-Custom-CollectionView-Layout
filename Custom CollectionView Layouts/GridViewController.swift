//
//  GridViewController.swift
//  Custom CollectionView Layouts
//
//  Created by Blake Merryman on 4/26/17.
//  Copyright © 2017 Blake Merryman. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {

  lazy var collectionView: UICollectionView = {

    let layout = GridViewLayout()
    layout.delegate = self

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
    collectionView.register(UICollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: UICollectionElementKindSectionHeader)
    collectionView.register(UICollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                            withReuseIdentifier: UICollectionElementKindSectionFooter)

    collectionView.backgroundColor = .white
    collectionView.dataSource = self
    collectionView.delegate = self

    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }

}

extension GridViewController: UICollectionViewDelegate {

}

extension GridViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 15
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
    reusableView.backgroundColor = kind == UICollectionElementKindSectionHeader ? .green : .red
    return reusableView
  }
  
}

extension GridViewController: GridViewLayoutDelegate {

  var separatorHeight: CGFloat {
    return 0.5
  }

  var separatorEdgeInsets: UIEdgeInsets {
    return UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 0.0)
  }

  var separatorBackgroundColor: UIColor {
    return .lightGray
  }

  func heightForHeader(in section: Int) -> CGFloat {
    return 50.0
  }

  func heightForFooter(in section: Int) -> CGFloat {
    return 44.0
  }

  func heightForItem(at indexPath: IndexPath) -> CGFloat {
    return 44.0
  }

}
