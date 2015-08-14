//
//  MultipeerService.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 14.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum MessageType {
    case ReadyStateChange
    case ReadyStateQuestion
    case Unknown
    
    func toString() -> String {
        switch(self) {
        case .ReadyStateChange: return "ReadyStateChange"
        case .ReadyStateQuestion: return "ReadyStateQuestion"
        case .Unknown: return "Unknown"
        }
    }
    
    static func fromString(string: String) -> MessageType {
        switch(string) {
        case "ReadyStateChange":
            return .ReadyStateChange
        case "ReadyStateQuestion":
            return .ReadyStateQuestion
        default:
            return .Unknown
        }
    }
}

enum CoffeeStatus {
    case Ready
    case NotReady
    case Unknown
    
    func toString() -> String {
        switch(self) {
        case .Ready: return "Ready"
        case .NotReady: return "NotReady"
        case .Unknown: return "Unknown"
        }
    }
    
    static func fromString(string: String) -> CoffeeStatus {
        switch(string) {
        case "Ready":
            return .Ready
        case "NotReady":
            return .NotReady
        default:
            return .Unknown
        }
    }
}

protocol MultipeerServiceDelegate {
    
    func multipeerService(service: MultipeerService, connectionStatusChanged status: String, forPeer peer: MCPeerID)
    func multipeerService(service: MultipeerService, readyStatusChanged status: CoffeeStatus, forPeer peer: MCPeerID)
    func multipeerService(service: MultipeerService, receivedReadyStatusQuestionFromPeer peer: MCPeerID)
    
}

class MultipeerService: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {

    //MARK: - Public Properties
    var delegate : MultipeerServiceDelegate?
    var numberOfPeers : Int {
        get {
            return (session != nil) ? session!.connectedPeers.count : 0
        }
    }
    
    //MARK: - Private Properties
    
    private var session : MCSession?
    private var advertiserAssistant : MCNearbyServiceAdvertiser?
    private var serviceBrowser : MCNearbyServiceBrowser?

    //MARK: - Init
    
    init(displayName: String, serviceType: String) {
        
        super.init()
        
        var peerID = MCPeerID(displayName: displayName)
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
        session!.delegate = self
        
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        serviceBrowser!.delegate = self
        serviceBrowser!.startBrowsingForPeers()
        
        advertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiserAssistant!.delegate = self
        advertiserAssistant!.startAdvertisingPeer()
        
        println("Starting advertising at serviceType '" + serviceType + "'")
    }
    
    //MARK: - Public Methods
    
    func sendBroadcastStatus(isReady: CoffeeStatus) {
        sendMessage(MessageType.ReadyStateChange, msg: isReady.toString(), peers: session!.connectedPeers as! [MCPeerID])

    }
    
    func sendStatusToPeer(isReady: CoffeeStatus, peer: MCPeerID) {
        sendMessage(MessageType.ReadyStateChange, msg: isReady.toString(), peers: [peer])
    }
    
    func sendStatusAskToPeer(peer: MCPeerID) {
        sendMessage(MessageType.ReadyStateQuestion, msg: "", peers: [peer])
    }
    
    //MARK: - Private Methods
    
    private func stringForPeerConnectionState(state: MCSessionState) -> String {
        switch(state) {
        case MCSessionState.Connected: return "Connected"
        case MCSessionState.Connecting: return "Connecting"
        case MCSessionState.NotConnected: return "Disconnected"
        }
    }
    
    private func sendMessage(type: MessageType, msg : String, peers: [MCPeerID]) {
        let package = type.toString() + ":" + msg
        let data = package.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let error : NSErrorPointer = nil
        
        if (session != nil) {
            if (!session!.sendData(data, toPeers: peers, withMode: MCSessionSendDataMode.Reliable, error: error)) {
                println("Error while sending data: " + error.debugDescription)
            }
        }
    }
    
    //MARK: - MCSessionDelegate
    
    @objc func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println("Peer " + peerID.displayName + " changed state to " + stringForPeerConnectionState(state))
        
        if (delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                delegate?.multipeerService(self, connectionStatusChanged: stringForPeerConnectionState(state), forPeer: peerID)
            })
        }
    }
    
    @objc func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        let message = NSString(data: data, encoding: NSUTF8StringEncoding)
        let exploded = split(message as! String) { $0 == ":" }
        if exploded.count > 0 {
            
            let messageType = MessageType.fromString(exploded[0])
            
            switch (messageType) {
            case .ReadyStateChange:
                if (delegate != nil) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if (exploded.count > 1) {
                            self.delegate!.multipeerService(self, readyStatusChanged: CoffeeStatus.fromString(exploded[1]), forPeer: peerID)
                        } else {
                            println("Missing second argument for readyStatusChanged")
                        }
                    })
                }
                break
            case .ReadyStateQuestion:
                if (delegate != nil) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate!.multipeerService(self, receivedReadyStatusQuestionFromPeer: peerID)
                    })
                }
                break
            default:
                println("Received unknown message.")
                break
            }
            
        }
    }
    
    @objc func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    @objc func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    @objc func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    //MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        invitationHandler(true, session)
    }

    //MARK: - MCNearbyServiceBrowserDelegate

    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 30)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        
    }
}