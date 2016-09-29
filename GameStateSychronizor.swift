//
//  GameStateSychronizor.swift
//  snake_burgerEater
//
//  Created by Chris Sun on 29/9/16.
//  Copyright © 2016 WEI. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol GameStateSychronizorDelegate {
    func addPlayer(PlayerId:String)
    func deletePlayer(playerId: String)
    func changeGameState(playerId: String, gameState: String)
}

class GameStateSychronizor : NSObject {
    
    private let ServiceType = "Slither.io"
   
    var myPeerId:MCPeerID?
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    var delegate : GameStateSychronizorDelegate?
    
    override init() {
        
        
        let date = NSDate();
        // "Apr 1, 2015, 8:53 AM" <-- local without seconds
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        let defaultTimeZoneStr = formatter.stringFromDate(date);
        let mydisplayName = UIDevice.currentDevice().name + defaultTimeZoneStr
        myPeerId = MCPeerID(displayName: mydisplayName)
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId!, discoveryInfo: nil, serviceType: ServiceType)
        
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId!, serviceType: ServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerId!, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session.delegate = self
        return session
    }()
    
    func sendGamestate(gamestate : String) {
        NSLog("%@", "sendGameState: \(gamestate)")
        
        if session.connectedPeers.count > 0 {
            let data = gamestate.dataUsingEncoding(NSUTF8StringEncoding)!
            do {
                try self.session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
                
            } catch _ {
                NSLog("%@", "error")
            }
            NSLog("%@", "sendGameState done!!!!!!!!")
        }
    }
}

extension GameStateSychronizor : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: ((Bool, MCSession?) -> Void)) {

        invitationHandler(true, self.session)
        
        
        
        

    }
    
    
}

extension GameStateSychronizor : MCNearbyServiceBrowserDelegate {
    /*
     func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
     NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
     }
     
     func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [NSObject : AnyObject]?) {
     NSLog("%@", "foundPeer: \(peerID)")
     NSLog("%@", "invitePeer: \(peerID)")
     browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
     }
     */
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
        NSLog("%@", "find a pair and invite it!!!!!!!!!!!!!!: \(peerID)")
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
}

extension MCSessionState {
    
    func stringValue() -> String {
        switch(self) {
        case .NotConnected: return "NotConnected"
        case .Connecting: return "Connecting"
        case .Connected: return "Connected"
        default: return "Unknown"
        }
    }
    
}

extension GameStateSychronizor : MCSessionDelegate {
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
        if(state.stringValue() == "NotConnected"){
            //Delete player
            self.delegate!.deletePlayer(peerID.displayName)
        }
        else if(state.stringValue() == "Connecting"){
            //doing nothing
            NSLog("%@", "The device is connecting!")
        }else if(state.stringValue() == "Connected"){
            //Add a player
            self.delegate!.addPlayer(peerID.displayName)
        }else{
            NSLog("%@", "Connecting Error")
        }
        //self.delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({$0.displayName}))
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data.length) bytes")
        let gamestate = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        self.delegate!.changeGameState(peerID.displayName, gameState: gamestate)
        //Change player's gamestate
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
}
