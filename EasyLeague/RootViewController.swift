//
//  RootViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/9/22.
//

import UIKit
import FirebaseAuth

protocol AuthStateChanger {
    func authenticated(user: User)
}

class RootViewController: UIViewController {
    
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var initial = true
        Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.presentLoginController()
            } else if initial, let user = user {
                self.presentHomeController(for: user)
            }
            initial = false
        }
    }
    
    func presentViewController(_ nextViewController: UIViewController) {
        currentViewController?.remove()
        add(nextViewController)
        currentViewController = nextViewController
    }
    
    func presentLoginController() {
        let logInController = LogInViewController()
        logInController.authStateChanger = self
        presentViewController(logInController)
    }
    
    func wrapPrimaryController(_ controller: UIViewController, imageName: String, selectedImageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.tabBarItem.selectedImage = UIImage(systemName: selectedImageName)
        return navController
    }
    
    func presentHomeController(for user: User) {
        let homeController = HomeViewController()
        homeController.user = user
        let profileController = ProfileViewController()
        profileController.user = user
        let tabController = UITabBarController()
        tabController.tabBar.tintColor = .label
        tabController.viewControllers = [
            wrapPrimaryController(homeController, imageName: "house", selectedImageName: "house.fill"),
            wrapPrimaryController(profileController, imageName: "person", selectedImageName: "person.fill"),
        ]
        presentViewController(tabController)
    }
    
}

extension RootViewController: AuthStateChanger {
    
    func authenticated(user: User) {
        presentHomeController(for: user)
    }
    
}
