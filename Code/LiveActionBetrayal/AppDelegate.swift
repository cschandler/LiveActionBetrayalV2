//
//  AppDelegate.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/13/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import Firebase
import ReSwift

typealias JSON = [String:AnyObject]
typealias SimpleClosure = () -> Void

@UIApplicationMain
class AppDelegate: UIResponder {

    public var window: UIWindow?

}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        IdleTimerManager.disable()
        Defaults.shared.brightness = UIScreen.main.brightness
        FirebaseApp.configure()
        ConnectionManager.shared.getConnectedPlayers()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        UIScreen.main.brightness = Defaults.shared.brightness
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppStore.shared.dispatch(GameAction.appForeground)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UIScreen.main.brightness = Defaults.shared.brightness
    }

}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}


