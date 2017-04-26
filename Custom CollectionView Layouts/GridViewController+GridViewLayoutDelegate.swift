//
//  GridViewController+GridViewLayoutDelegate.swift
//  Custom CollectionView Layouts
//
//  Created by Blake Merryman on 4/26/17.
//  Copyright © 2017 Blake Merryman. All rights reserved.
//

import UIKit

extension GridViewController: GridViewLayoutDelegate {

  var separatorHeight: CGFloat {
    return 0.5
  }

  var separatorEdgeInsets: UIEdgeInsets {
    return UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 0.0)
  }

  var separatorBackgroundColor: UIColor {
    return .blue
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

  func widthForSection(section: Int) -> CGFloat {
    if UIScreen.main.bounds.width > 414 {
      // Greater than iPhone Plus width
      return collectionView.bounds.width / CGFloat(self.numberOfSections(in: collectionView))
    }
    else {
      return collectionView.bounds.width
    }
  }
  
}
