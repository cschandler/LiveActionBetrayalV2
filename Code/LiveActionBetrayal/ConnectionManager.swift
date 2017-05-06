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
    private let playerUpdatedListener: FIRDatabaseHandle
    private let playerAddedListener: FIRDatabaseHandle
    private let torchListener: FIRDatabaseHandle
    
    lazy var database: FIRDatabaseReference = {
        return FIRDatabase.database().reference()
    }()
    
    lazy var storage: FIRStorageReference = {
        return FIRStorage.storage().reference()
    }()
    
    enum DatabaseTopLevel: String {
        case players
        case torchesOn
    }
    
    init() {
        let playerRef = FIRDatabase.database().reference().child(DatabaseTopLevel.players.rawValue)
        let torchRef = FIRDatabase.database().reference().child(DatabaseTopLevel.torchesOn.rawValue)
        
        playerUpdatedListener = playerRef.observe(.childChanged, with: { snapshot in
            print("PLAYER UPDATED LISTENER")
            print("------")
        })
        
        playerAddedListener = playerRef.observe(.childAdded, with: { snapshot in
            print("PLAYER ADDED LISTENER")
            print("------")
            
            guard let json = snapshot.value as? JSON,
                let explorer = Explorer(json: json) else {
                    return
            }
            
            AppStore.shared.dispatch(AppAction.added(explorer))
        })
        
        torchListener = torchRef.observe(.value, with: { snapshot in
            print("TORCH LISTENER")
            print("------")
            
            guard let json = snapshot.value as? JSON,
                let torchesOn = json["torchesOn"] as? Bool else {
                return
            }
            
            AppStore.shared.dispatch(AppAction.torchesOn(torchesOn))
        })
    }
    
    func getConnectedPlayers() {
        database.child("players").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let json = snapshot.value as? JSON else {
                return
            }
            
            for value in json.values {
               guard let json = value as? JSON,
                let explorer = Explorer(json: json) else {
                    return
                }
                
                AppStore.shared.dispatch(AppAction.added(explorer))
            }
        })
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
    
    func logWatcherIn() -> Promise<Void> {
        return Promise { fulfill in
            FIRAuth.auth()?.signIn(withEmail: "watcher@test.com", password: self.firepass, completion: { (user, error) in
                guard let _ = user else {
                    guard let error = error else { return }
                    fulfill(.failure(error))
                    return
                }
                
                fulfill(.success())
            })
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
    
    private func addPlayerToDatabase(withId uid: String, name: String, andAttribute attribute: Attribute) -> Promise<Void> {
        return Promise { fulfill in
            
            let values: [String: AnyObject] = [
                "uid": uid as NSString,
                "name": name as NSString,
                "attribute": attribute.name as NSString,
                "torch": false as AnyObject,
                "traitor": false as AnyObject
            ]
            
            self.database.child("players/\(uid)").setValue(values) { (error, ref) in
                print("FIREBASE ADD USER")
                if let error = error {
                    fulfill(.failure(error))
                    return
                }
                print("------")
                fulfill(.success())
            }
        }
    }
    
    private func uploadPicture(image: UIImage?, withId uid: String) -> Promise<Void> {
        return Promise { fulfill in
            
            guard let image = image else {
                fulfill(.failure(SerializationError.missing("Picture")))
                return
            }
            
            guard let data = UIImageJPEGRepresentation(image, 0.8) else {
                fulfill(.failure(SerializationError.corrupted("Failed to convert UIImage to Data")))
                return
            }
            
            dump(data)
            
            let imageRef = self.storage.child("images/\(uid).jpg")
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.put(data, metadata: metadata) { (metadata, error) in
                print("FIREBASE PUT DATA")
                guard let metadata = metadata else {
                    guard let error = error else { return }
                    fulfill(.failure(error))
                    return
                }
                print("metadata: \(String(describing: metadata))")
                print("------")
                fulfill(.success())
            }
        }
    }
    
    func downloadPicture(withId uid: String) -> Promise<UIImage> {
        return Promise { fulfill in
            let imageRef = self.storage.child("images/\(uid).jpg")
            
            imageRef.downloadURL(completion: { (url, error) in
                print("FIREBASE DOWNLOAD IMAGE URL")
                guard let url = url else {
                    guard let error = error else { return }
                    fulfill(.failure(error))
                    return
                }
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else {
                        guard let error = error else { return }
                        fulfill(.failure(error))
                        return
                    }
                    
                    guard let image = UIImage(data: data) else {
                        fulfill(.failure(SerializationError.corrupted("Could not convert data into UIImage.")))
                        return
                    }
                    
                    fulfill(.success(image))

                }.resume()
            })
        }
    }
    
    func toggleLights(on: Bool) {
        database.child(DatabaseTopLevel.torchesOn.rawValue).setValue(on) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
    }
    
}

enum SerializationError: Error {
    case failed
    case missing(String)
    case corrupted(String)
    case invalid(String, Any)
}
