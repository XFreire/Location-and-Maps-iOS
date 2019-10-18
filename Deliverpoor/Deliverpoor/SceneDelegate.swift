//
//  SceneDelegate.swift
//  Deliverpoor
//
//  Created by Alexandre Freire García on 12/10/2019.
//  Copyright © 2019 Alexandre Freire García. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        let listViewController = ListViewController()
        
        let listNavigationController = UINavigationController(rootViewController: listViewController)

        window?.rootViewController = listNavigationController
        window?.makeKeyAndVisible()
    }
}
