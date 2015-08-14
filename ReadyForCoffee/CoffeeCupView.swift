//
//  CoffeeCupView.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 13.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation
import Cocoa
import Darwin
import SnapKit

class CoffeeCupView : NSView {
    
    //MARK: - Private Properties
    private var firstPath : CGMutablePathRef!
    private var secondPath : CGMutablePathRef!
    
    private var leftSteamLayer : CAShapeLayer!
    private var middleSteamLayer : CAShapeLayer!
    private var rightSteamLayer : CAShapeLayer!
    private var coffeeImage : NSImageView!
    
    private var color : NSColor = Commons.Colors.primaryFontColor
    
    //MARK: - Init
    
    override init(frame: NSRect) {
        
        super.init(frame: frame)
        
        //Add Layer
        let layer = CALayer()
        self.wantsLayer = true
        self.layer = layer
        
        //Add Coffee-Image and "Waves"
        coffeeImage = NSImageView()
        coffeeImage.image = GetTintedImage(NSImage(named: "CoffeeCup")!, tint: self.color)
        coffeeImage.imageScaling = NSImageScaling.ImageScaleProportionallyUpOrDown
        self.addSubview(coffeeImage)
        
        coffeeImage.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.snp_width)
            make.centerX.equalTo((self.snp_centerX))
            make.height.equalTo(self.snp_height).multipliedBy(Commons.Dimensions.CoffeeCupView.coffeeCupHeightPercentage)
            make.bottom.equalTo(0)
        }
        
        leftSteamLayer = CAShapeLayer()
        leftSteamLayer.strokeColor = color.CGColor
        leftSteamLayer.lineWidth = 2
        leftSteamLayer.fillColor = NSColor.clearColor().CGColor
        self.layer!.addSublayer(leftSteamLayer)
        
        middleSteamLayer = CAShapeLayer()
        middleSteamLayer.strokeColor = color.CGColor
        middleSteamLayer.lineWidth = 2
        middleSteamLayer.fillColor = NSColor.clearColor().CGColor
        self.layer!.addSublayer(middleSteamLayer)
        
        rightSteamLayer = CAShapeLayer()
        rightSteamLayer.strokeColor = color.CGColor
        rightSteamLayer.lineWidth = 2
        rightSteamLayer.fillColor = NSColor.clearColor().CGColor
        self.layer!.addSublayer(rightSteamLayer)
        
        updateSteam()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    
    override func layout() {
        super.layout()
        
        updateSteam()
        
        leftSteamLayer.frame = CGRectMake(coffeeImage.frame.origin.x + coffeeImage.frame.size.width * 0.25, coffeeImage.frame.height + frame.height * Commons.Dimensions.CoffeeCupView.spacePercentage, frame.width * Commons.Dimensions.CoffeeCupView.steamWidthPercentage / 2, frame.height * 0.3)
        middleSteamLayer.frame = CGRectMake(coffeeImage.frame.origin.x + coffeeImage.frame.size.width * 0.5 - frame.width * Commons.Dimensions.CoffeeCupView.steamWidthPercentage / 2, coffeeImage.frame.height + frame.height * Commons.Dimensions.CoffeeCupView.spacePercentage, frame.width * Commons.Dimensions.CoffeeCupView.steamWidthPercentage / 2, frame.height * 0.3)
        rightSteamLayer.frame = CGRectMake(coffeeImage.frame.origin.x + coffeeImage.frame.size.width * 0.75 - frame.width * Commons.Dimensions.CoffeeCupView.steamWidthPercentage, coffeeImage.frame.height + frame.height * Commons.Dimensions.CoffeeCupView.spacePercentage, frame.width * Commons.Dimensions.CoffeeCupView.steamWidthPercentage / 2, frame.height * 0.3)
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
    
    //MARK: - Private Methods
    private func updateSteam() {
        
        var xOrigin = coffeeImage.frame.width * 0.05 / 2.0
        var yOrigin = CGFloat(0)
        var steamHeight = frame.height * Commons.Dimensions.CoffeeCupView.steamHeightPercentage
        var steamWidth = coffeeImage.frame.width * Commons.Dimensions.CoffeeCupView.steamWidthPercentage
        
        //Create first path for animation
        firstPath = CGPathCreateMutable()
        CGPathMoveToPoint(firstPath, nil, xOrigin, yOrigin)
        CGPathAddArcToPoint(firstPath, nil, xOrigin, yOrigin, xOrigin + steamWidth / 2, yOrigin + steamHeight * 0.25, steamWidth)
        CGPathAddArcToPoint(firstPath, nil, xOrigin + steamWidth / 2, yOrigin + steamHeight * 0.25, xOrigin - steamWidth / 2, yOrigin + steamHeight * 0.5, steamWidth)
        CGPathAddArcToPoint(firstPath, nil, xOrigin - steamWidth / 2, yOrigin + steamHeight * 0.5, xOrigin + steamWidth / 2, yOrigin + steamHeight * 0.75, steamWidth)
        CGPathAddArcToPoint(firstPath, nil, xOrigin + steamWidth / 2, yOrigin + steamHeight * 0.75, xOrigin, yOrigin + steamHeight, steamWidth)
        
        //Create second path for animation
        secondPath = CGPathCreateMutable()
        CGPathMoveToPoint(secondPath, nil, xOrigin, yOrigin)
        CGPathAddArcToPoint(secondPath, nil, xOrigin, yOrigin, xOrigin - steamWidth / 2, yOrigin + steamHeight * 0.25, steamWidth)
        CGPathAddArcToPoint(secondPath, nil, xOrigin - steamWidth / 2, yOrigin + steamHeight * 0.25, xOrigin + steamWidth / 2, yOrigin + steamHeight * 0.5, steamWidth)
        CGPathAddArcToPoint(secondPath, nil, xOrigin + steamWidth / 2, yOrigin + steamHeight * 0.5, xOrigin - steamWidth / 2, yOrigin + steamHeight * 0.75, steamWidth)
        CGPathAddArcToPoint(secondPath, nil, xOrigin - steamWidth / 2, yOrigin + steamHeight * 0.75, xOrigin, yOrigin + steamHeight, steamWidth)
        
        //Add Coffee-Animation
        var animation = CABasicAnimation(keyPath: "path")
        animation.duration = 2
        animation.repeatCount = FLT_MAX
        animation.autoreverses = true
        animation.fromValue = firstPath
        animation.toValue = secondPath
        leftSteamLayer.addAnimation(animation, forKey: "animationPath")
        middleSteamLayer.addAnimation(animation, forKey: "animationPath")
        rightSteamLayer.addAnimation(animation, forKey: "animationPath")
        
    }
    
}