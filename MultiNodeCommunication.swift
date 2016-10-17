
import Foundation
import MultipeerConnectivity


protocol MultiNodeCommunicationManagerDelegate {
    
    func connectedDevicesChanged(manager : MultiNodeCommunication, connectedDevices: [String])
    func dataGet(manager : MultiNodeCommunication, data: String)
    
    func lostConnected(lostUserName: String)
    
}

protocol OnlineModeSearchDelegate {
    func findGameRoom(findGameRoom: Bool)->Bool
}

class MultiNodeCommunication : NSObject {
    
    private let service = "snake"
    private var accept = false
    
    
    private let myPeerId:MCPeerID?
    
    public let serviceAdvertiser : MCNearbyServiceAdvertiser
    public let serviceBrowser : MCNearbyServiceBrowser
    var displayName:String?
    var delegate : MultiNodeCommunicationManagerDelegate?
    var mainScenceDelegate: OnlineModeSearchDelegate?
    
    override init() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let username = userDefaults.valueForKey("username") {
            displayName = username as? String
        }else{
            let date = NSDate()
            let fmt = NSDateFormatter()
            fmt.dateFormat = "HH:mm:ss.SSS"
            displayName = fmt.stringFromDate(date)
        }
        
        myPeerId = MCPeerID(displayName: displayName!)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId!, discoveryInfo: nil, serviceType: service)
        
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId!, serviceType: service)
        
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
    
    func sendData(dataContent : String) {
        //NSLog("%@", "sendColor: \(dataContent)")
        let dataContent_copy = dataContent
        let lockQueue = dispatch_queue_create("com.test.LockQueue", nil)
        dispatch_sync(lockQueue) {
            // code
            
            if session.connectedPeers.count > 0 {
                
                if let data = dataContent_copy.dataUsingEncoding(NSUTF8StringEncoding){
                    
                    do {
                        try self.session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
                        
                    } catch _ {
                        NSLog("%@", "error")
                    }
                    
                }else{
                    print("error connectedPeers send")
                }
                //NSLog("%@", "sendColor done!!!!!!!!")
            }
        }
        
    }
    func getName()->String{
        return self.displayName!
    }
    
}

extension MultiNodeCommunication : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: ((Bool, MCSession?) -> Void)) {
        //let accept = mcSession.myPeerID.hashValue > peerID.hashValue
        //self.OnlineModeSearchDelegate!.findGameRoom(findGameRoom:true)
        
        findGameRoomTag = true
        invitationHandler(true, self.session)
    
        //if accept {
        //   stopAdvertising()
        //}
    }
    
    
}

extension MultiNodeCommunication : MCNearbyServiceBrowserDelegate {
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
        
        self.delegate?.lostConnected(peerID.displayName)
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

extension MultiNodeCommunication : MCSessionDelegate {
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
        self.delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({$0.displayName}))
        
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data.length) bytes")
        let str = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        
        //////////////////////////////////////////////////////////
        
        self.delegate?.dataGet(self, data: str)
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
