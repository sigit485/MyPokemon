//
//  AppDelegate.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: PokemonListView())
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

}

