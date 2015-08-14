//
//  Commons.swift
//  ReadyForCoffeeTestApp
//
//  Created by Kevin Skyba on 14.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation

struct Commons {
    
    struct Settings {
        
        static var serviceNamePrefix : String {
            get {
                var version : AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
                var versionString = (version as! String).stringByReplacingOccurrencesOfString(".", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
                return "RFC-" + versionString + "-"
            }
        }
    }
    
}