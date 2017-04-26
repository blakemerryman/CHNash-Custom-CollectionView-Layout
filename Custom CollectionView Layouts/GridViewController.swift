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

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self),
                                                  for: indexPath)
    cell.backgroundColor = indexPath.section % 2 == 0 ? .lightGray : .white
    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: kind,
                                                                       for: indexPath)
    reusableView.backgroundColor = kind == UICollectionElementKindSectionHeader ? .green : .red
    return reusableView
  }
  
}
