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
import FirebaseStorage

final class ConnectionManager {
    
    static let shared = ConnectionManager()
    
    private let firepass = "P7mYDDnT&M[UcZU2Q7"
    
    lazy var database: FIRDatabaseReference = {
        return FIRDatabase.database().reference()
    }()
    
    lazy var storage: FIRStorageReference = {
        return FIRStorage.storage().reference()
    }()
    
    init() {
        
    }
    
    func addPlayer(withMetadata player: PlayerMetadata?) -> Promise<Void> {
        return Promise { fulfill in
            guard let player = player, let attribute = player.attribute else {
                fulfill(.failure(SerializationError.missing("Player metadata or attribute nil")))
                return
            }
            
            self.createUser(withName: player.name)
                .onSuccess { user in
                    let add = self.addPlayerToDatabase(withId: user.uid, name: player.name, andAttribute: attribute)
                    let upload = self.uploadPicture(image: player.picture, withId: user.uid)
                    zip(add, upload)
                        .onSuccess { _,_ in fulfill(.success()) }
                        .onFailure { error in fulfill(.failure(error)) }
                        .call()
                }
                .onFailure { error in fulfill(.failure(error)) }
                .call()
        }
    }
    
    private func createUser(withName name: String) -> Promise<FIRUser> {
        return Promise { fulfill in
            
            let email = "\(name)@test.com"
            
            FIRAuth.auth()?.createUser(withEmail: email, password: self.firepass) { (user, error) in
                print("FIREBASE CREATE USER")
                guard let user = user else {
                    guard let error = error else { return }
                    fulfill(.failure(error))
                    return
                }
                print("user: \(String(describing: user))")
                print("------")
                fulfill(.success(user))
            }
        }
    }
    
    func addPlayerToDatabase(withId uid: String, name: String, andAttribute attribute: Attribute) -> Promise<Void> {
        return Promise { fulfill in
            
            let values: [String: AnyObject] = [
                "name": name as NSString,
                "attribute": attribute.name as NSString,
                "torch": false as AnyObject,
                "traitor": false as AnyObject
            ]
            
            self.database.child("players/\(uid)").setValue(values, withCompletionBlock: { (error, ref) in
                print("FIREBASE DATABASE ADD USER")
                if let error = error {
                    fulfill(.failure(error))
                    return
                }
                print("------")
                fulfill(.success())
            })
        }
    }
    
    func uploadPicture(image: UIImage?, withId uid: String) -> Promise<Void> {
        return Promise { fulfill in
            
            guard let image = image, let data = UIImageJPEGRepresentation(image, 0.8) else {
                fulfill(.failure(SerializationError.corrupted("Failed to convert UIImage to Data")))
                return
            }
            
            dump(data)
            
            let imageRef = self.storage.child("images/\(uid).jpg")
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.put(data, metadata: metadata, completion: { (metadata, error) in
                print("FIREBASE PUT DATA")
                guard let metadata = metadata else {
                    guard let error = error else { return }
                    fulfill(.failure(error))
                    return
                }
                print("metadata: \(String(describing: metadata))")
                print("------")
                fulfill(.success())
            })
        }
    }
    
}

enum SerializationError: Error {
    case failed
    case missing(String)
    case corrupted(String)
    case invalid(String, Any)
}
