//
//  MainPopoverView.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 13.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation
import Cocoa
import SnapKit

class MainPopoverView : NSView {
    
    var coffeeCupView : CoffeeCupView = CoffeeCupView()
    var titleView : VerticalCenteredTextField = VerticalCenteredTextField()
    var yesView : NSTextField = NSTextField()
    var noView : NSTextField = NSTextField()
    var slider : NSSlider = NSSlider()
    var subTitleView : VerticalCenteredTextField = VerticalCenteredTextField()
    var informationButton : NSButton = NSButton()
    
    var informationMenu : NSMenu = NSMenu(title: "Test")
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        //Add Layer
        let layer = CALayer()
        layer.backgroundColor = Commons.Colors.secondaryColor.CGColor
        layer.borderWidth = 5
        layer.borderColor = Commons.Colors.primaryColor.CGColor
        
        self.wantsLayer = true
        self.layer = layer
        
        //Add CoffeeCupView
        self.addSubview(coffeeCupView)
        
        //Add TitleView
        titleView.font = NSFont(name: Commons.Dimensions.MainPopoverView.titleFontName, size: Commons.Dimensions.MainPopoverView.titleFontSize)
        titleView.stringValue = "Coffee?"
        titleView.editable = false
        titleView.textColor = Commons.Colors.primaryFontColor
        titleView.backgroundColor = NSColor.clearColor()
        titleView.bordered = false
        titleView.bezeled = false
        titleView.alignment = NSTextAlignment.CenterTextAlignment
        self.addSubview(titleView)
        
        //Add yesView
        yesView.font = NSFont(name: Commons.Dimensions.MainPopoverView.optionsFontName, size: Commons.Dimensions.MainPopoverView.optionsFontSize)
        yesView.stringValue = "Yes"
        yesView.editable = false
        yesView.textColor = Commons.Colors.primaryFontColor
        yesView.backgroundColor = NSColor.clearColor()
        yesView.bordered = false
        yesView.bezeled = false
        yesView.alignment = NSTextAlignment.CenterTextAlignment
        self.addSubview(yesView)
        
        //Add noView
        noView.font = NSFont(name: Commons.Dimensions.MainPopoverView.optionsFontName, size: Commons.Dimensions.MainPopoverView.optionsFontSize)
        noView.stringValue = "No"
        noView.editable = false
        noView.textColor = Commons.Colors.primaryFontColor
        noView.backgroundColor = NSColor.clearColor()
        noView.bordered = false
        noView.bezeled = false
        noView.alignment = NSTextAlignment.CenterTextAlignment
        self.addSubview(noView)
        
        //Add Slider
        var sliderCell = slider.cell() as! NSSliderCell
        slider.sliderType = NSSliderType.LinearSlider
        slider.tickMarkPosition = NSTickMarkPosition.Above
        sliderCell.numberOfTickMarks = 3
        sliderCell.allowsTickMarkValuesOnly = true
        slider.maxValue = 3
        slider.minValue = 1
        slider.stringValue = "2"
        self.addSubview(slider)
        
        //Add subTitleView
        subTitleView.font = NSFont(name: Commons.Dimensions.MainPopoverView.subTitleFontName, size: Commons.Dimensions.MainPopoverView.subTitleFontSize)
        subTitleView.stringValue = "5 / 10"
        subTitleView.editable = false
        subTitleView.textColor = Commons.Colors.primaryFontColor
        subTitleView.backgroundColor = NSColor.clearColor()
        subTitleView.bordered = false
        subTitleView.bezeled = false
        subTitleView.alignment = NSTextAlignment.CenterTextAlignment
        self.addSubview(subTitleView)
        
        
        //Information Button
        var buttonCell = informationButton.cell() as! NSButtonCell
        buttonCell.image = GetTintedImage(NSImage(named: "Information")!, tint: Commons.Colors.primaryFontColor)
        buttonCell.imageScaling = NSImageScaling.ImageScaleProportionallyUpOrDown
        buttonCell.action = Selector("informationClicked:")
        buttonCell.target = self
        buttonCell.bordered = false
        buttonCell.menu = informationMenu
        self.addSubview(informationButton)
        
        //Information Menu
        informationMenu.addItemWithTitle("Test", action: Selector("test:"), keyEquivalent: "")
        
        
        //Layout
        coffeeCupView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(Commons.Dimensions.MainPopoverView.coffeeCupSize)
            make.height.equalTo(Commons.Dimensions.MainPopoverView.coffeeCupSize)
            make.center.equalTo(self.snp_center)
        }
        
        titleView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(Commons.Dimensions.MainPopoverView.titleOffsetTop)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(Commons.Dimensions.MainPopoverView.titleHeight)
        }
        
        slider.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(coffeeCupView.snp_bottom).offset(Commons.Dimensions.MainPopoverView.sliderOffsetTop)
            make.width.equalTo(Commons.Dimensions.MainPopoverView.sliderWidth)
            make.height.equalTo(Commons.Dimensions.MainPopoverView.sliderHeight)
        }
        
        noView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(slider.snp_centerY)
            make.right.equalTo(slider.snp_left).offset(-Commons.Dimensions.MainPopoverView.optionsOffset)
            make.width.equalTo(Commons.Dimensions.MainPopoverView.optionsWidth)
            make.height.equalTo(Commons.Dimensions.MainPopoverView.optionsHeight)
        }
        
        yesView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(slider.snp_centerY)
            make.left.equalTo(slider.snp_right).offset(Commons.Dimensions.MainPopoverView.optionsOffset)
            make.width.equalTo(Commons.Dimensions.MainPopoverView.optionsWidth)
            make.height.equalTo(Commons.Dimensions.MainPopoverView.optionsHeight)
        }
        
        subTitleView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp_centerX)
            make.bottom.equalTo(self.snp_bottom).offset(-Commons.Dimensions.MainPopoverView.subTitleOffsetBottom)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(Commons.Dimensions.MainPopoverView.subTitleHeight)
        }
        
        informationButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.snp_right).offset(-Commons.Dimensions.MainPopoverView.informationButtonOffset)
            make.bottom.equalTo(self.snp_bottom).offset(-Commons.Dimensions.MainPopoverView.informationButtonOffset)
            make.height.equalTo(Commons.Dimensions.MainPopoverView.informationButtonSize)
            make.width.equalTo(Commons.Dimensions.MainPopoverView.informationButtonSize)
        }

    }
    
    func informationClicked(sender: AnyObject) {
        NSMenu.popUpContextMenu(informationMenu, withEvent: NSEvent(), forView: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func GetTintedImage(image:NSImage, tint:NSColor) -> NSImage {
        
        let tinted = image.copy() as! NSImage
        tinted.lockFocus()
        tint.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        NSRectFillUsingOperation(imageRect, NSCompositingOperation.CompositeSourceAtop)
        
        tinted.unlockFocus()
        return tinted
    }
    
}