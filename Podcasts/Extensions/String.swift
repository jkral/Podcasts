//
//  String.swift
//  Podcasts
//
//  Created by Jeff Kral on 3/2/18.
//  Copyright © 2018 Jeff Kral. All rights reserved.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
