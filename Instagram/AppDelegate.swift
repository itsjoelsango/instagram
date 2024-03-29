//
//  AppDelegate.swift
//  Instagram
//
//  Created by Jo Michael on 7/19/23.
//

import UIKit
import ParseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let url = "https://parseapi.back4app.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // step 1: initialize Parse server connection

        let configuration = ParseClientConfiguration {
            $0.applicationId = APPLICATION_ID
            $0.clientKey = CLIENT_KEY
            $0.server = self.url
        }
        Parse.initialize(with: configuration)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

