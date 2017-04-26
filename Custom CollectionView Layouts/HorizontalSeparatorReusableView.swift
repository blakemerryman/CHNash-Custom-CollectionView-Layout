//
//  HorizontalSeparatorReusableView.swift
//  Custom CollectionView Layouts
//
//  Created by Blake Merryman on 4/26/17.
//  Copyright © 2017 Blake Merryman. All rights reserved.
//

import UIKit

class HorizontalSeparatorReusableViewLayoutAttributes: UICollectionViewLayoutAttributes {

  var backgroundColor: UIColor?
  var edgeInsets: UIEdgeInsets?

  override public func copy(with zone: NSZone? = nil) -> Any {
    let copy = super.copy(with: zone)
    if let attributesCopy = copy as? HorizontalSeparatorReusableViewLayoutAttributes {
      attributesCopy.backgroundColor = backgroundColor
      attributesCopy.edgeInsets = edgeInsets
    }
    return copy
  }

}

open class HorizontalSeparatorReusableView: UICollectionReusableView {

  public let separatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  var leftEdgeConstraint: NSLayoutConstraint?
  var rightEdgeConstraint: NSLayoutConstraint?

  public override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(separatorView)
    leftEdgeConstraint = separatorView.leftAnchor.constraint(equalTo: leftAnchor)
    rightEdgeConstraint = separatorView.rightAnchor.constraint(equalTo: rightAnchor)

    NSLayoutConstraint.activate([
      leftEdgeConstraint!,
      rightEdgeConstraint!,
      separatorView.topAnchor.constraint(equalTo: topAnchor),
      separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    if let attributes = layoutAttributes as? HorizontalSeparatorReusableViewLayoutAttributes {
      separatorView.backgroundColor = attributes.backgroundColor
      leftEdgeConstraint?.constant = attributes.edgeInsets?.left ?? 0.0
      rightEdgeConstraint?.constant = -(attributes.edgeInsets?.right ?? 0.0)
      separatorView.setNeedsLayout()
    }
  }
  
}
