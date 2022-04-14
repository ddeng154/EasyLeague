//
//  RootViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/9/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AuthStateChanger {
    func authenticated(user: User)
}

protocol UserInterfaceStyleWrapper {
    func get() -> UIUserInterfaceStyle
    func set(_ style: UIUserInterfaceStyle)
}

class RootViewController: UIViewController {
    
    var setUserInterfaceStyle: ((UIUserInterfaceStyle) -> Void)!
    
    lazy var appLogo = createImageView(name: "AppLogo") { imageView in
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    var currentViewController: UIViewController?
    
    var userMapListener: ListenerRegistration?
    
    deinit {
        userMapListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeSharedResources()
        
        view.backgroundColor = .appAccent

        view.addSubview(appLogo)

        NSLayoutConstraint.activate([
            appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        var initial = true
        Auth.auth().addStateDidChangeListener { _, firebaseUser in
            if firebaseUser == nil {
                if initial {
                    self.set(self.get())
                }
                self.presentLoginController()
            } else if initial, let firebaseUser = firebaseUser {
                Firestore.firestore().documentForUser(firebaseUser.uid).getDocument(as: User.self) { result in
                    self.set(self.get())
                    switch result {
                        case .success(let user):
                            self.presentHomeController(for: user)
                        case .failure:
                            self.presentLoginController()
                    }
                }
            }
            initial = false
        }
    }
    
    func initializeSharedResources() {
        userMapListener = Firestore.firestore().userCollection.addSnapshotListener { querySnapshot, _ in
            guard let snapshot = querySnapshot else { return }
            for user in snapshot.documents.compactMap({ qds in try? qds.data(as: User.self)}) {
                Shared.userMap[user.id] = user
            }
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
    
    func wrapPrimaryController(_ controller: UIViewController, title: String, imageName: String, selectedImageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.tintColor = .appAccent
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.tabBarItem.selectedImage = UIImage(systemName: selectedImageName)
        return navController
    }
    
    func presentHomeController(for user: User) {
        let homeController = HomeViewController()
        homeController.user = user
        let chatController = ChatHomeViewController()
        chatController.user = user
        let profileController = ProfileViewController()
        profileController.user = user
        profileController.userInterfaceStyle = self
        let tabController = UITabBarController()
        tabController.tabBar.standardAppearance = UITabBarAppearance()
        tabController.tabBar.standardAppearance.configureWithTransparentBackground()
        tabController.tabBar.tintColor = .appAccent
        tabController.viewControllers = [
            wrapPrimaryController(homeController, title: "Home", imageName: "house", selectedImageName: "house.fill"),
            wrapPrimaryController(chatController, title: "Chat", imageName: "ellipsis.bubble", selectedImageName: "ellipsis.bubble.fill"),
            wrapPrimaryController(profileController, title: "Profile", imageName: "person", selectedImageName: "person.fill"),
        ]
        presentViewController(tabController)
    }
    
}

extension RootViewController: AuthStateChanger {
    
    func authenticated(user: User) {
        presentHomeController(for: user)
    }
    
}

extension RootViewController: UserInterfaceStyleWrapper {
    
    static let userInterfaceStyleKey = "EasyLeagueUserInterfaceStyleKey"
    
    func get() -> UIUserInterfaceStyle {
        UIUserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: Self.userInterfaceStyleKey)) ?? .unspecified
    }
    
    func set(_ style: UIUserInterfaceStyle) {
        UserDefaults.standard.set(style.rawValue, forKey: Self.userInterfaceStyleKey)
        setUserInterfaceStyle(style)
    }
    
}
