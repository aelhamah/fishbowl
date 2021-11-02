//
//  AppDelegate.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 9/7/21.
//

import UIKit

var window: UIWindow?

 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     // Override point for customization after application launch.
        
     window = UIWindow()
     if let window = window {
         // UIWindow is a reference type
         window.rootViewController = UINavigationController(rootViewController: MainVC())
         window.makeKeyAndVisible()
     }
     return true
 }

