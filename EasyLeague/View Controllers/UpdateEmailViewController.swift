//
//  UpdateEmailViewController.swift
//  EasyLeague
//
//  Created by Chen Zhou on 4/12/22.
//

import UIKit
import FirebaseAuth

class UpdateEmailViewController: UIViewController {
    
    var user: User!
    
    lazy var saveButton = createBarButton(item: .save, action: #selector(saveButtonPressed))
    
    lazy var emailField = createTextField(placeholder: "New email address") { field in
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .left
    }
    
    lazy var passwordField = createTextField(placeholder: "Enter password") { field in
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .left
        field.isSecureTextEntry = true
    }
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Update email address"
        navigationItem.rightBarButtonItem = saveButton
        
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentSignUpError(_ message: String) {
        presentSimpleAlert(title: "Failed to update email", message: message)
    }
}


@objc extension UpdateEmailViewController {
    
    func saveButtonPressed() {
        guard emailField.hasText, let email = emailField.text else {
            return presentSignUpError("Email field cannot be empty")
        }
        
        guard passwordField.hasText, let password = passwordField.text else {
            return presentSignUpError("Password field cannot be empty")
        }
        
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: password)
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                self.presentSignUpError(error.localizedDescription)
            } else {
                user?.updateEmail(to: email) { error in
                    if let error = error {
                        self.presentSignUpError(error.localizedDescription)
                    } else {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        })
        
    }
    
}
