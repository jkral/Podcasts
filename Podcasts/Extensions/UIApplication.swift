//
//  UIApplication.swift
//  Podcasts
//
//  Created by Jeff Kral on 3/11/18.
//  Copyright © 2018 Jeff Kral. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}


