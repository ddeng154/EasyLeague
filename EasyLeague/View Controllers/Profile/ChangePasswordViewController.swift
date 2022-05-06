//
//  ChangePasswordViewController.swift
//  EasyLeague
//
//  Created by Daniel Deng on 4/13/22.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    var user: User!
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))
    
    lazy var oldPasswordField = createTextField(placeholder: "Old Password") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
    }
    
    lazy var newPasswordField = createTextField(placeholder: "New Password") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
    }
    
    lazy var repeatNewPasswordField = createTextField(placeholder: "Repeat New Password") { field in
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
        
        navigationItem.title = "Change Password"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton
        
        stackView.addArrangedSubview(oldPasswordField)
        stackView.addArrangedSubview(newPasswordField)
        stackView.addArrangedSubview(repeatNewPasswordField)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentChangePasswordError(_ message: String) {
        presentSimpleAlert(title: "Change Password Error", message: message)
    }
    
}

@objc extension ChangePasswordViewController {
    
    func doneButtonPressed() {
        guard oldPasswordField.hasText, let oldPassword = oldPasswordField.text else {
            return presentChangePasswordError("Old Password field is empty")
        }
        guard newPasswordField.hasText, let newPassword = newPasswordField.text else {
            return presentChangePasswordError("New Password field is empty")
        }
        guard repeatNewPasswordField.text == newPassword else {
            return presentChangePasswordError("New Passwords do not match")
        }
        guard let user = Auth.auth().currentUser, let email = user.email else {
            return presentChangePasswordError("Could not find user information")
        }
        let spinner = addSpinner()
        user.reauthenticate(with: EmailAuthProvider.credential(withEmail: email, password: oldPassword)) { _, error in
            if let error = error {
                spinner.remove()
                self.presentChangePasswordError(error.localizedDescription)
            } else {
                user.updatePassword(to: newPassword) { error in
                    spinner.remove()
                    if let error = error {
                        self.presentChangePasswordError(error.localizedDescription)
                    } else {
                        self.popFromNavigation()
                    }
                }
            }
        }
    }
    
}
