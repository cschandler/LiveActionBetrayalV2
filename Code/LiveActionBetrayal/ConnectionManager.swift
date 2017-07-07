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
    private let watcherEmail = "watcher@test.com"
    
    private let playerUpdatedListener: FIRDatabaseHandle
    private let playerAddedListener: FIRDatabaseHandle
    private let torchListener: FIRDatabaseHandle
    private let watcherListener: FIRDatabaseHandle
    private var messageListener: FIRDatabaseHandle?
    private var cardListener: FIRDatabaseHandle?
    private var hauntListener: FIRDatabaseHandle
    private var hauntNameListener: FIRDatabaseHandle
    
    lazy var database: FIRDatabaseReference = {
        return FIRDatabase.database().reference()
    }()
    
    lazy var storage: FIRStorageReference = {
        return FIRStorage.storage().reference()
    }()
    
    enum DatabaseTopLevel: String {
        case players
        case torchesOn
        case messages
        case watcher
        case items
        case hauntTriggered
        case hauntName
    }
    
    var currentUser: FIRUser? {
        return FIRAuth.auth()?.currentUser
    }
    
    var currentUserID: String? {
        return currentUser?.uid
    }
    
    init() {
        let playerRef = FIRDatabase.database().reference().child(DatabaseTopLevel.players.rawValue)
        let torchRef = FIRDatabase.database().reference().child(DatabaseTopLevel.torchesOn.rawValue)
        let watcherRef = FIRDatabase.database().reference().child(DatabaseTopLevel.watcher.rawValue)
        let hauntRef = FIRDatabase.database().reference().child(DatabaseTopLevel.hauntTriggered.rawValue)
        let hauntNameRef = FIRDatabase.database().reference().child(DatabaseTopLevel.hauntName.rawValue)
        
        playerUpdatedListener = playerRef.observe(.childChanged, with: { snapshot in
            print("PLAYER UPDATED LISTENER")
            print("------")
            
            guard let json = snapshot.value as? JSON,
                let explorer = Explorer(json: json) else {
                    return
            }
            
            AppStore.shared.dispatch(AppAction.updated(explorer))
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
            
            guard let torchesOn = snapshot.value as? Bool else {
                return
            }
            
            AppStore.shared.dispatch(AppAction.torchesOn(torchesOn))
        })
        
        watcherListener = watcherRef.observe(.value, with: { snapshot in
            print("WATCHER LISTENER")
            print("------")
            
            guard let watcherID = snapshot.value as? String else {
                return
            }
            
            let watcher = Watcher(identifier: watcherID)
            
            AppStore.shared.dispatch(AppAction.watcher(watcher))
        })
        
        hauntListener = hauntRef.observe(.value, with: { snapshot in
            print("HAUNT LISTENER")
            print("------")
            
            guard let hauntTriggered = snapshot.value as? Bool, hauntTriggered == true else {
                return
            }
            
            AppStore.shared.dispatch(AppAction.triggerHaunt)
        })
        
        hauntNameListener = hauntNameRef.observe(.value, with: { snapshot in
            print("HAUNT NAME LISTENER")
            print("------")
            
            guard let name = snapshot.value as? String else {
                return
            }
            
            AppStore.shared.dispatch(AppAction.hauntName(name))
        })
    }
    
    // MARK: - Players
    
    func getConnectedPlayers() {
        database.child("players").observeSingleEvent(of: .value, with: { snapshot in
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
            FIRAuth.auth()?.signIn(withEmail: self.watcherEmail, password: self.firepass, completion: { (user, error) in
                guard let user = user else {
                    guard let error = error else {
                        return
                    }
                    fulfill(.failure(error))
                    return
                }
                
                self.database.child(DatabaseTopLevel.watcher.rawValue).setValue("\(user.uid)")
                
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
                print("------")
                fulfill(.success(user))
            }
        }
    }
    
    private func addPlayerToDatabase(withId uid: String, name: String, andAttribute attribute: Attribute) -> Promise<Void> {
        return Promise { fulfill in
            
            let values: JSON = [
                "uid": uid as NSString,
                "name": name as NSString,
                "attribute": attribute.name as NSString,
                "torch": false as AnyObject,
                "traitor": false as AnyObject
            ]
            
            self.database.child("\(DatabaseTopLevel.players.rawValue)/\(uid)").setValue(values) { (error, ref) in
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
    
    // MARK: - Profile Picture
    
    func uploadPicture(image: UIImage?, withId uid: String) -> Promise<Void> {
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
                guard metadata != nil else {
                    guard let error = error else { return }
                    fulfill(.failure(error))
                    return
                }
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
    
    // MARK: - Lights
    
    func toggleLights(on: Bool) {
        database.child(DatabaseTopLevel.torchesOn.rawValue).setValue(on)
        
        for player in AppStore.shared.state.connectedPlayers {
            database.child("\(DatabaseTopLevel.players.rawValue)/\(player.identifier)/torch").setValue(on)
        }
    }
    
    func toggleLight(forPlayer player: Explorer, on: Bool) {
        database.child("\(DatabaseTopLevel.players.rawValue)/\(player.identifier)/torch").setValue(on)
    }
    
    func logIn(player: Explorer) -> Promise<Void> {
        return Promise { fulfill in
            
            let email = "\(player.name)@test.com"
            
            FIRAuth.auth()?.signIn(withEmail: email, password: self.firepass, completion: { (user, error) in
                print("PLAYER SIGN IN")
                print("------")
                guard let _ = user else {
                    guard let error = error else { return }
                    fulfill(.failure(error))
                    return
                }
                
                fulfill(.success())
            })
        }
    }
    
    // MARK: - Cards
    
    func getCards() {
        
        let cardRef = self.database.child(DatabaseTopLevel.items.rawValue)
        
        cardListener = cardRef.observe(.value, with: { snapshot in
            print("GETTING CARDS")
            print("------")
            
            guard let currentUserId = self.currentUser?.uid,
                let json = snapshot.value as? JSON else {
                    return
            }
            
            let cards: [Card] = json.flatMap { Card(json: $0.value as! JSON) }
            
            if currentUserId == AppStore.shared.state.watcher?.identifier ?? "" {
                // We only want to haunt to be tested for once per omen added
                // If we ever add support for mutiple watchers we'll need a better solution
                HauntController.triggerHauntIfNeeded(with: AppStore.shared.state.cards, newCards: cards)
                
                AppStore.shared.dispatch(AppAction.cards(cards))
                
            } else {
                let filteredCards = cards.filter { $0.owner == currentUserId }
                AppStore.shared.dispatch(AppAction.cards(filteredCards))
            }
        })
    }
    
    func addCard(card: Card) -> Promise<Void> {
        return Promise { fulfill in
            
            let values = card.toJSON()
            
            let itemRef = self.database.child(DatabaseTopLevel.items.rawValue).childByAutoId()
            
            itemRef.setValue(values, withCompletionBlock: { (error, ref) in
                print("ADD ITEM")
                print("------")
                if let error = error {
                    fulfill(.failure(error))
                    return
                }
                
                fulfill(.success())
            })
        }
    }
    
    // MARK: - Messages
    
    func getMessages(forPlayer uid: String) {
        
        let messageRef = self.database.child("messages/\(uid)")
        
        messageListener = messageRef.observe(.value, with: { snapshot in
            print("GETTING MESSAGES")
            print("------")
            
            guard let json = snapshot.value as? JSON else {
                return
            }
            
            let messages = json
                .values.flatMap { Message.init(json: $0 as! JSON) }
                .sorted { $0.timestamp < $1.timestamp }
            
            AppStore.shared.dispatch(AppAction.messages(messages))
        })
    }
    
    func send(message: Message, toPlayer uid: String) {
        print("SENDING MESSAGE")
        
        let messageRef = self.database.child("messages/\(uid)").childByAutoId()
        let values = message.toJSON()
        messageRef.setValue(values)
    }
    
    func resetMessages() {
        messageListener = nil
        AppStore.shared.dispatch(AppAction.messages([]))
    }
    
    // MARK: - Haunt
    
    func setHaunt(withName name: String) {
        database.child("\(DatabaseTopLevel.hauntName.rawValue)").setValue(name)
    }
    
    func triggerHaunt() {
        database.child("\(DatabaseTopLevel.hauntTriggered.rawValue)").setValue(true)
    }
    
    func getHaunt(withName name: String) -> Promise<String> {
        return Promise { fulfill in
            guard let currentUserID = self.currentUserID,
                let currentExplorer = AppStore.shared.state.connectedPlayers.filter({ $0.identifier == currentUserID }).first else {
                    fulfill(.failure(StateError.noValidPlayer))
                    return
            }
            
            let type = currentExplorer.isTraitor ? "traitor" : "explorer"
            
            let hauntRef = self.storage.child("haunts/\(type)/\(name).txt")
            
            hauntRef.downloadURL(completion: { (url, error) in
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
                    
                    guard let text = String(data: data, encoding: .utf8) else {
                        fulfill(.failure(SerializationError.corrupted("Haunt text")))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        fulfill(.success(text))
                    }
                }.resume()
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

enum StateError: Error {
    case noValidPlayer
}
