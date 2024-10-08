//
//  AppDelegate.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 06.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        
        UIColorValueTransformer.register()
        WeekDaysValueTransformer.register()
        
        return true
    }
}
