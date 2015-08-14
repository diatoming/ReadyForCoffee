//
//  Commons.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 13.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation
import Cocoa

struct Commons {
    
    struct Colors {
        
        static let primaryColor : NSColor = NSColor(deviceRed: 153/255, green: 98/255, blue: 42/255, alpha: 1)
        static let secondaryColor : NSColor = NSColor(deviceRed: 201/255, green: 159/255, blue: 105/255, alpha: 1)
        
        static let primaryFontColor : NSColor = NSColor(deviceRed: 221/255, green: 204/255, blue: 173/255, alpha: 1)
        
    }
    
    struct Dimensions {
        
        struct CoffeeCupView {
            
            static let steamHeightPercentage : CGFloat = 0.3
            static let spacePercentage : CGFloat = 0.1
            static let coffeeCupHeightPercentage : CGFloat = 0.6
            static let steamWidthPercentage : CGFloat = 0.06
            
        }
        
        struct MainPopoverView {
            
            static let titleOffsetTop : CGFloat = 15
            static let titleFontName : String = "Channel"
            static let titleFontSize : CGFloat = 30
            static let titleHeight : CGFloat = 60
            
            static let subTitleOffsetBottom : CGFloat = 15
            static let subTitleFontName : String = "Channel"
            static let subTitleFontSize : CGFloat = 15
            static let subTitleHeight : CGFloat = 18
            
            static let optionsFontName : String = "Channel"
            static let optionsFontSize : CGFloat = 14
            static let optionsHeight : CGFloat = 20
            static let optionsOffset : CGFloat = 10
            static let optionsWidth : CGFloat = 50
            
            static let coffeeCupSize : CGFloat = 125
            
            static let informationButtonSize : CGFloat = 25
            static let informationButtonOffset : CGFloat = 10
            
            static let sliderOffsetTop : CGFloat = 10
            static let sliderHeight : CGFloat = 50
            static let sliderWidth : CGFloat = 150
            
        }
    }
    
}