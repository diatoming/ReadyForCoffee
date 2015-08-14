//
//  MultipeerService.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 14.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerService: NSObject, MCSessionDelegate {
    
    //MARK: - Private Properties
    
    private var session : MCSession?
    private var advertiserAssistant : MCAdvertiserAssistant?

    //MARK: - Init
    
    init(displayName: String, serviceType: String) {
        
        super.init()
        
        var peerID = MCPeerID(displayName: displayName)
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session!.delegate = self
        
        advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        advertiserAssistant!.start()
    }
    
    //MARK: - Private Methods
    private func stringForPeerConnectionState(state: MCSessionState) -> String {
        switch(state) {
        case MCSessionState.Connected: return "Connected"
        case MCSessionState.Connecting: return "Connecting"
        case MCSessionState.NotConnected: return "Not Connected"
        }
    }
    
    //MARK: - MCSessionDelegate
    
    @objc func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println("Peer " + peerID.displayName + " changed state to " + stringForPeerConnectionState(state))
    }
    
    @objc func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
    }
    
    @objc func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    @objc func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    @objc func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
}