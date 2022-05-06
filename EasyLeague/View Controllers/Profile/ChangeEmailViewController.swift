//
//  ChangeEmailViewController.swift
//  EasyLeague
//
//  Created by Daniel Deng on 4/12/22.
//

import UIKit
import FirebaseAuth

class ChangeEmailViewController: UIViewController {
    
    var user: User!
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))
    
    lazy var emailField = createTextField(placeholder: "New Email") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.keyboardType = .emailAddress
    }
    
    lazy var passwordField = createTextField(placeholder: "Current Password") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
    }
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Change Email"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton
        
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentChangeEmailError(_ message: String) {
        presentSimpleAlert(title: "Change Email Error", message: message)
    }
    
}

@objc extension ChangeEmailViewController {
    
    func doneButtonPressed() {
        guard emailField.hasText, let email = emailField.text else {
            return presentChangeEmailError("Email field is empty")
        }
        guard passwordField.hasText, let password = passwordField.text else {
            return presentChangeEmailError("Password field is empty")
        }
        guard let user = Auth.auth().currentUser, let currentEmail = user.email else {
            return presentChangeEmailError("Could not find user information")
        }
        let spinner = addSpinner()
        user.reauthenticate(with: EmailAuthProvider.credential(withEmail: currentEmail, password: password)) { _, error in
            if let error = error {
                spinner.remove()
                self.presentChangeEmailError(error.localizedDescription)
            } else {
                user.updateEmail(to: email) { error in
                    spinner.remove()
                    if let error = error {
                        self.presentChangeEmailError(error.localizedDescription)
                    } else {
                        self.popFromNavigation()
                    }
                }
            }
        }
    }
    
}
