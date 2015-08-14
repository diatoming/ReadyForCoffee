//
//  MainPopoverViewModel.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 13.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation
import Cocoa
import Bond

class MainPopoverViewModel: NSObject {

    private let connection  = Dynamic<Connection?>(nil)
    
    let headline            = Dynamic<String>("Coffee?")
    let yes                 = Dynamic<String>("Yes")
    let no                  = Dynamic<String>("No")
    let status              = Dynamic<String>("")
    let coffeeImage         = Dynamic<String>("CoffeeCup")
    
    override init() {
        super.init()
        
        //Setup DataBinding
        self.setupDataBinding()
    }
    
    func setupDataBinding() {

        connection.filter({ (con : Connection?) -> Bool in
            return (con != nil)
        }).map { (con : Connection?) -> String in
            return "" + con!.readyCoffees!.description + " / " + con!.totalCoffees!.description
        } ->> status
    }
    
}