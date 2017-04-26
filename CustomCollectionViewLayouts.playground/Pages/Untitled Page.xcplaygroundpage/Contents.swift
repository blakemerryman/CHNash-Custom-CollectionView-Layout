//: # Custom Collection View Layouts
//: ### _Reimplementing UITableView_

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


@objc protocol GridViewLayoutDelegate {
  @objc optional func heightForHeader(in section: Int) -> CGFloat
  @objc optional func heightForFooter(in section: Int) -> CGFloat
  @objc optional func heightForItem(at indexPath: IndexPath) -> CGFloat

  @objc optional var separatorHeight: CGFloat
  @objc optional var separatorEdgeInsets: UIEdgeInsets // Ignores the top and bottom insets.
  @objc optional var separatorBackgroundColort: UIColor
}

class GridViewLayout: UICollectionViewLayout {

  var delegate: GridViewLayoutDelegate?

  private var contentSize: CGSize = .zero
  private var shouldPage = false

  private(set) var headerLayoutAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]
  private(set) var footerLayoutAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]
  private(set) var itemLayoutAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]
  private(set) var separatorLayoutAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]

  override var collectionViewContentSize: CGSize {
    return contentSize
  }

  override func prepare() {
    super.prepare()

    headerLayoutAttributes.removeAll()
    footerLayoutAttributes.removeAll()
    itemLayoutAttributes.removeAll()
    separatorLayoutAttributes.removeAll()

    register(HorizontalSeparatorReusableView.self, forDecorationViewOfKind: String(describing: HorizontalSeparatorReusableView.self))

    var xCursor: CGFloat = 0.0
    var yCursor: CGFloat = 0.0






    xCursor = self.collectionView?.bounds.width ?? 0.0

    contentSize = CGSize(width: xCursor, height: yCursor)
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    var layoutAttributes: [UICollectionViewLayoutAttributes] = []

    headerLayoutAttributes.forEach { (indexPath, attributes) in
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }

    footerLayoutAttributes.forEach { (indexPath, attributes) in
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }

    itemLayoutAttributes.forEach { (indexPath, attributes) in
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }

    separatorLayoutAttributes.forEach { (indexPath, attributes) in
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }

    return layoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return itemLayoutAttributes[indexPath]
  }

  override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                     at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if elementKind == UICollectionElementKindSectionHeader {
      return headerLayoutAttributes[indexPath]
    }
    else if elementKind == UICollectionElementKindSectionFooter {
      return footerLayoutAttributes[indexPath]
    }
    else {
      return nil
    }
  }

  override func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                  at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return separatorLayoutAttributes[indexPath]
  }

}


class GridViewController: UIViewController {

  lazy var collectionView: UICollectionView = {

    let layout = GridViewLayout()

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

    cell.layer.borderWidth = 1.0
    cell.layer.borderColor = UIColor.blue.cgColor

    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)

    reusableView.layer.borderWidth = 1.0
    reusableView.layer.borderColor = UIColor.red.cgColor

    return reusableView
  }

}

presentViewController(controller: GridViewController())
