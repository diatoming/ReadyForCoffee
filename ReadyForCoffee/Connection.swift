//
//  Connection.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 14.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation

class Connection {
    
    //MARK: - Public Properties
    
    var isActive : Bool?
    var isReadyForCoffee : Bool?
    var totalCoffees : Int?
    var readyCoffees : Int?
    
    //MARK: - Init
    
    required init?() {
        isActive = false
        isReadyForCoffee = false
        totalCoffees = 0
        readyCoffees = 0
    }
    
}