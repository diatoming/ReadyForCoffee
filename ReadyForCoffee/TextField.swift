//
//  TextField.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 13.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation
import Cocoa

class VerticalCenteredTextField: NSTextField {

    func titleRectForBounds(rect: NSRect) -> NSRect {
        var titleFrame = super.frame
        var titleSize = self.attributedStringValue.size
        titleFrame.origin.y = rect.origin.y + (rect.size.height - titleSize.height) / 2
        return titleFrame
    }
    
    override func drawRect(dirtyRect: NSRect) {
        var titleRect = titleRectForBounds(dirtyRect)
        self.attributedStringValue.drawInRect(titleRect)
    }
}