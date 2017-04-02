//
//  ConnectionManager.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/14/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift
import PinkyPromise
import FirebaseAuth
import FirebaseDatabase

final class ConnectionManager {
    
    static let shared = ConnectionManager()
    private let firepass = "P7mYDDnT&M[UcZU2Q7"
    
    lazy var database: FIRDatabaseReference = {
        return FIRDatabase.database().reference()
    }()
    
    init() {
        
    }
    
    func addPlayer(withMetadata metadata: PlayerMetadata?) {
        guard let metadata = metadata else { return }
        
        let email = "\(metadata.name).live.action.betrayal.v2@gmail.com"
        FIRAuth.auth()?.createUser(withEmail: email, password: firepass) { (user, error) in
            print("FIREBASE CREATE USER")
            print("user: \(String(describing: user))")
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            print("------")
            
            guard let user = user else { return }
            
            let values: [String: AnyObject] = [
                "name": metadata.name as NSString,
                "torch": TorchManager.isOn as NSNumber,
                "traitor": 0 as NSNumber
            ]
            
            self.database.child("players").child(user.uid).setValue(values)
        }
    }
    
    
}

enum SerializationError: Error {
    case failed
    case missing(String)
    case corrupted(String)
    case invalid(String, Any)
}
