//
//  AppDelegate.swift
//  Podcasts
//
//  Created by Jeff Kral on 2/25/18.
//  Copyright © 2018 Jeff Kral. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()        
        window?.rootViewController = MainTabBarController()
        
        return true
    }


}

