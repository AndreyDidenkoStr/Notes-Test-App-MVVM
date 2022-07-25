//
//  SceneDelegate.swift
//  Notes Test App MVVM
//
//  Created by Andrey Kapitalov on 18.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let viewController = MainTableViewController()
        let navigatinController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigatinController
        window.makeKeyAndVisible()
        self.window = window
    }
}

