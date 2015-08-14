//
//  Bond+NSSlider.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 14.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation
import Cocoa
import Bond

var valueDynamicHandleNSSlider: UInt8 = 0;

extension NSSlider: Dynamical, Bondable {
    
    public var designatedDynamic: Dynamic<Double> {
        return self.dynValue
    }
    
    public var designatedBond: Bond<Double> {
        return self.designatedDynamic.valueBond
    }
    
    public var dynValue: Dynamic<Double> {
        if let d: AnyObject = objc_getAssociatedObject(self, &valueDynamicHandleNSSlider) {
            return (d as? Dynamic<Double>)!
        } else {
            let d = InternalDynamic<Double>(self.doubleValue)
            let bond = Bond<Double>() { [weak self] v in // NSTextView cannot be referenced weakly
                if let s = self {
                    s.doubleValue = v
                }
            }
            
            d.bindTo(bond, fire: false, strongly: false)
            d.retain(bond)
            objc_setAssociatedObject(self, &valueDynamicHandleNSSlider, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }
    
}


public func <->> (left: Dynamic<Double>, right: NSSlider) {
    left <->> right.designatedDynamic
}

public func <->> (left: NSSlider, right: Dynamic<Double>) {
    left.designatedDynamic <->> right
}