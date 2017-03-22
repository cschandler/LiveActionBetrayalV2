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

final class ConnectionHandler {
    
    static let shared = ConnectionHandler()
    
    private var connectionManager: ConnectionManager?
    
    func setup(withPeer peer: Peer) {
        connectionManager = ConnectionManager(peer: peer)
    }
    
    var manager: ConnectionManager {
        if let manager = connectionManager {
            return manager
        } else {
            connectionManager = ConnectionManager()
            return connectionManager!
        }
    }
}

final class ConnectionManager: NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let serviceName = "lab-v2"
    private let peerId: MCPeerID
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    fileprivate let gameStore: Store<AppState>
    fileprivate let connectionStore: Store<ConnectionState>
    
    public let session: MCSession
    
    fileprivate let peer: Peer?
    
    init(peer: Peer? = nil, store: Store<AppState> = AppStore.shared) {
        self.peer = peer
        self.peerId = MCPeerID(displayName: peer?.name ?? UIDevice.current.name)
        self.session = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceName)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceName)
        self.gameStore = store
        self.connectionStore = ConnectionStore.shared
        
        super.init()
        
        session.delegate = self
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    func send(metadata: Peer, toPeers: [MCPeerID] = ConnectionHandler.shared.manager.session.connectedPeers) {
        guard let data = try? JSONSerialization.data(withJSONObject: metadata.toJSON(), options: []) else {
            print("action JSON serialization failed")
            return
        }
        
        send(data: data)
    }
    
    func send(action: PeerAction, toPeers: [MCPeerID] = ConnectionHandler.shared.manager.session.connectedPeers) {
        print("send: \(action.description) to peers:")
        dump(session.connectedPeers)
        
        guard let data = try? JSONSerialization.data(withJSONObject: action.toJSON(), options: []) else {
            print("action JSON serialization failed")
            return
        }
        
        send(data: data)
    }
    
    private func send(data: Data, toPeers: [MCPeerID] = ConnectionHandler.shared.manager.session.connectedPeers) {
        do {
            try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let error {
            print("Error for sending: \(error)")
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
        
        if state == .connected, let peer = peer {
            send(metadata: peer, toPeers: [peerID])
        }
        
        DispatchQueue.main.async {
            self.connectionStore.dispatch(ConnectionAction.peerChangedState(peerID, state))
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let json = object as? JSON else {
            print("json from data serialization failed")
            return
        }
        
        if let action = PeerAction(json: json) {
            print(action.description)
            
            DispatchQueue.main.async {
                self.gameStore.dispatch(action)
            }
            return
        }
        
        do {
            let peer = try Peer(json: json)
            DispatchQueue.main.async {
                self.connectionStore.dispatch(ConnectionAction.recievedMetadata(peer))
            }
            return
        } catch {
            print(error)
        }

    }
    
    // Required but unused functions
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
}

enum SerializationError: Error {
    case failed
    case missing(String)
    case corrupted(String)
    case invalid(String, Any)
}
