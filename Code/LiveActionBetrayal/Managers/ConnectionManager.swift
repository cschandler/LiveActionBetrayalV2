//
//  ConnectionManager.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/14/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import ReSwift

protocol ConnectionDelegate {
    func peer(_ peer: MCPeerID, didChangeState: MCSessionState)
}

final class ConnectionHandler {
    
    static let sharedInstance = ConnectionHandler()
    
    var manager: ConnectionManager! {
        get {
            if self.manager == nil {
                self.manager = ConnectionManager()
                return self.manager
            }
            return self.manager
        }
        set {
            self.manager = newValue
        }
    }
    
    func setup(withPeerName name: String) {
        manager = ConnectionManager(peerName: name)
    }
}

final class ConnectionManager: NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let serviceName = "lab-v2"
    private let peerId: MCPeerID
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    fileprivate let store: Store<AppState>
    
    public let session: MCSession
    
    var connectionDelegate: ConnectionDelegate?
    
    init(peerName: String = UIDevice.current.name, store: Store<AppState> = AppStore.shared) {
        peerId = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceName)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceName)
        self.store = store
        
        super.init()
        
        session.delegate = self
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    func send(action: PeerAction, toPeers: [MCPeerID] = ConnectionHandler.sharedInstance.manager.session.connectedPeers) {
        print("send: \(action.description) to peers:")
        dump(session.connectedPeers)
        
        guard let data = try? JSONSerialization.data(withJSONObject: action.toJSON(), options: []) else {
            print("action JSON serialization failed")
            return
        }
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                print("Error for sending: \(error)")
            }
        }
        
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
}

extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
}

extension ConnectionManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID)")
        print("invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")
    }
    
}

extension ConnectionManager: MCSessionDelegate {
    
    func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state.rawValue)")
        connectionDelegate?.peer(peerID, didChangeState: state)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let json = object as? [String:String],
            let action = PeerAction(json: json) else {
            print("json from data serialization failed")
            return
        }
        
        print(action.description)
        
        store.dispatch(action)
    }
    
    // Required but unused functions
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
}
