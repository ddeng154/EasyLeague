//
//  ProfileViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/31/22.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    var user: User!
    
    var userInterfaceStyle: UserInterfaceStyleWrapper!
    
    lazy var userLabel = createLabel(text: user.name)
    
    lazy var userPhoto = createImageView { imageView in
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.kf.setImage(with: URL(string: self.user.photoURL), placeholder: UIImage(systemName: "photo.circle"))
    }
    
    lazy var userStackView = createHorizontalStack(for: [userLabel, userPhoto])
    
    lazy var overrideSystemAppearanceLabel = createLabel(text: "Override System Appearance")
    
    lazy var overrideSystemAppearanceSwitch = createSwitch(action: #selector(overrideSystemAppearanceSwitchPressed))
    
    lazy var overrideSystemAppearanceStackView = createHorizontalStack(for: [overrideSystemAppearanceLabel, overrideSystemAppearanceSwitch])
    
    lazy var darkModeLabel = createLabel(text: "Dark Mode")
    
    lazy var darkModeSwitch = createSwitch(action: #selector(darkModeSwitchPressed))
    
    lazy var darkModeStackView = createHorizontalStack(for: [darkModeLabel, darkModeSwitch])
    
    lazy var spacer = createSpacer()
    
    lazy var logOutButton = createButton(title: "Log Out", action: #selector(logOutButtonPressed))
    
    lazy var stackView = createVerticalStack()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Profile"
        
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(overrideSystemAppearanceStackView)
        stackView.addArrangedSubview(darkModeStackView)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(logOutButton)
        
        updateDarkModeControls()
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func updateDarkModeControls() {
        let style = userInterfaceStyle.get()
        if style == .unspecified {
            overrideSystemAppearanceSwitch.setOn(false, animated: false)
            darkModeStackView.isHidden = true
        } else {
            overrideSystemAppearanceSwitch.setOn(true, animated: false)
            darkModeStackView.isHidden = false
            darkModeSwitch.setOn(style == .dark, animated: false)
        }
    }

}

@objc extension ProfileViewController {
    
    func overrideSystemAppearanceSwitchPressed() {
        if overrideSystemAppearanceSwitch.isOn {
            userInterfaceStyle.set(.light)
        } else {
            userInterfaceStyle.set(.unspecified)
        }
        updateDarkModeControls()
    }
    
    func darkModeSwitchPressed() {
        if darkModeSwitch.isOn {
            userInterfaceStyle.set(.dark)
        } else {
            userInterfaceStyle.set(.light)
        }
    }
    
    func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch {
            presentSimpleAlert(title: "Log Out Error", message: error.localizedDescription)
        }
    }
    
}
