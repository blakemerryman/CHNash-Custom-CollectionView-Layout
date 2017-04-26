//
//  AppDelegate.swift
//  Custom CollectionView Layouts
//
//  Created by Blake Merryman on 4/26/17.
//  Copyright © 2017 Blake Merryman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  lazy var window: UIWindow? = UIWindow(frame:UIScreen.main.bounds)

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window?.rootViewController = UINavigationController(rootViewController: GridViewController())
    window?.makeKeyAndVisible()
    return true
  }

}

