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
import MultipeerConnectivity

class MainPopoverViewModel: NSObject, MultipeerServiceDelegate {

    //MARK: - Private Properties
    
    private var service : MultipeerService?     = nil
    private let isActive                        = Dynamic<Bool>(true)
    private let totalCoffees                    = Dynamic<Int>(0)
    private let readyCoffees                    = Dynamic<Int>(0)
    private var coffeeStatus                    = [MCPeerID: CoffeeStatus]()
    
    //MARK: - Public Properties
    
    let headline            = Dynamic<String>("Coffee?")
    let yes                 = Dynamic<String>("Yes")
    let no                  = Dynamic<String>("No")
    let status              = Dynamic<String>("")
    let coffeeImage         = Dynamic<String>("CoffeeCup")
    let serviceID           = Dynamic<String>("Default")
    let isReadyForCoffee    = Dynamic<CoffeeStatus>(CoffeeStatus.NotReady)

    
    //MARK: - Init
    
    override init() {
        super.init()
        
        //Setup MultipeerService
        self.setupMultipeerService()
        
        //Setup DataBinding
        self.setupDataBinding()
    }
    
    //MARK: - Private Methods
    
    var sliderBond : Bond<CoffeeStatus>?
    private func setupDataBinding() {
        
        reduce(totalCoffees, readyCoffees) { (total, ready) -> String in
            return String(ready) + " / " + String(total)
        } ->> status
        
        sliderBond = Bond<CoffeeStatus> { value in
            println(value.toString())
            
            self.service!.sendBroadcastStatus(self.isReadyForCoffee.value)
            self.readyCoffees.value = self.coffeeStatus.values.filter({ (element) -> Bool in return element == CoffeeStatus.Ready }).array.count + ((self.isReadyForCoffee.value == CoffeeStatus.Ready) ? 1 : 0)
        }
        isReadyForCoffee ->| sliderBond!

        //Update readyCoffees and totalCoffees value
        totalCoffees.value = coffeeStatus.count + 1
        readyCoffees.value = coffeeStatus.values.filter({ (element) -> Bool in return element == CoffeeStatus.Ready }).array.count + ((isReadyForCoffee.value == CoffeeStatus.Ready) ? 1 : 0)
    }
    
    private func setupMultipeerService() {
        service = MultipeerService(displayName: NSFullUserName(), serviceType: Commons.Settings.serviceNamePrefix + serviceID.value)
        service!.delegate = self
    }
    
    //MARK: - MultipeerServiceDelegate
    
    func multipeerService(service: MultipeerService, connectionStatusChanged status: String, forPeer peer: MCPeerID) {
        if (status == "Disconnected") {
            coffeeStatus.removeAtIndex(coffeeStatus.indexForKey(peer)!)
        } else if (status == "Connected") {
            coffeeStatus[peer] = CoffeeStatus.Unknown
            service.sendStatusAskToPeer(peer)
        }
        
        //Update readyCoffees and totalCoffees value
        totalCoffees.value = coffeeStatus.count + 1
        readyCoffees.value = coffeeStatus.values.filter({ (element) -> Bool in return element == CoffeeStatus.Ready }).array.count + ((isReadyForCoffee.value == CoffeeStatus.Ready) ? 1 : 0)
    }
    
    func multipeerService(service: MultipeerService, readyStatusChanged status: CoffeeStatus, forPeer peer: MCPeerID) {
        coffeeStatus[peer] = status
        
        //Update readyCoffees and totalCoffees value
        totalCoffees.value = coffeeStatus.count + 1
        readyCoffees.value = coffeeStatus.values.filter({ (element) -> Bool in return element == CoffeeStatus.Ready }).array.count + ((isReadyForCoffee.value == CoffeeStatus.Ready) ? 1 : 0)
    }
    
    func multipeerService(service: MultipeerService, receivedReadyStatusQuestionFromPeer peer: MCPeerID) {
        service.sendStatusToPeer(isReadyForCoffee.value, peer: peer)
        
        //Update readyCoffees value
        readyCoffees.value = coffeeStatus.values.filter({ (element) -> Bool in return element == CoffeeStatus.Ready }).array.count + ((isReadyForCoffee.value == CoffeeStatus.Ready) ? 1 : 0)
    }
    
}