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

    //MARK: - Private Properties
    private var service : MultipeerService?     = nil
    private let connection                      = Dynamic<Connection?>(nil)
    
    //MARK: - Public Properties
    
    let headline            = Dynamic<String>("Coffee?")
    let yes                 = Dynamic<String>("Yes")
    let no                  = Dynamic<String>("No")
    let status              = Dynamic<String>("")
    let coffeeImage         = Dynamic<String>("CoffeeCup")
    
    let serviceID           = Dynamic<String>("Default")
    
    //MARK: - Init
    
    override init() {
        super.init()
        
        //Setup MultipeerService
        self.setupMultipeerService()
        
        //Setup DataBinding
        self.setupDataBinding()
    }
    
    //MARK: - Private Methods
    
    private func setupDataBinding() {

        connection.filter({ (con : Connection?) -> Bool in
            return (con != nil)
        }).map { (con : Connection?) -> String in
            return "" + con!.readyCoffees!.description + " / " + con!.totalCoffees!.description
        } ->> status
    }
    
    private func setupMultipeerService() {
        service = MultipeerService(displayName: NSFullUserName(), serviceType: Commons.Settings.serviceNamePrefix + serviceID.value)
    }
    
}