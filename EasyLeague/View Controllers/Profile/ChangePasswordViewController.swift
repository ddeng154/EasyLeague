//
//  ChangePasswordViewController.swift
//  EasyLeague
//
//  Created by Chen Zhou on 4/13/22.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    var user: User!
    
    lazy var saveButton = createBarButton(item: .save, action: #selector(saveButtonPressed))
    
    lazy var oldPasswordField = createTextField(placeholder: "Enter old password") { field in
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .left
        field.isSecureTextEntry = true
    }
    
    lazy var newPasswordField = createTextField(placeholder: "Enter new password") { field in
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .left
        field.isSecureTextEntry = true
    }
    
    lazy var newPasswordField2 = createTextField(placeholder: "Reenter new password") { field in
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
        
        navigationItem.title = "Change Password"
        navigationItem.rightBarButtonItem = saveButton
        
        stackView.addArrangedSubview(oldPasswordField)
        stackView.addArrangedSubview(newPasswordField)
        stackView.addArrangedSubview(newPasswordField2)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentSignUpError(_ message: String) {
        presentSimpleAlert(title: "Failed to change password", message: message)
    }
}


@objc extension ChangePasswordViewController {
    
    func saveButtonPressed() {
    
        guard oldPasswordField.hasText, let oldPassword = oldPasswordField.text else {
            return presentSignUpError("Password field cannot be empty")
        }
        
        guard newPasswordField.hasText, let newPassword = newPasswordField.text else {
            return presentSignUpError("Password field cannot be empty")
        }
        
        guard newPasswordField2.hasText, let newPassword2 = newPasswordField2.text else {
            return presentSignUpError("Password field cannot be empty")
        }
        
        guard newPassword == newPassword2 else {
            return presentSignUpError("New passwords do not match")
        }
        
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPassword)
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                self.presentSignUpError(error.localizedDescription)
            } else {
                user?.updatePassword(to: newPassword) { error in
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
