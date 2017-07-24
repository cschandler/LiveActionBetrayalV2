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

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?

}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
        UIApplication.shared.isIdleTimerDisabled = true
        Defaults.shared.brightness = UIScreen.main.brightness
        FIRApp.configure()
        ConnectionManager.shared.getConnectedPlayers()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        UIScreen.main.brightness = Defaults.shared.brightness
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
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


