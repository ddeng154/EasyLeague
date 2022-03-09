//
//  SignUpViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "EasyLeague"
        return label
    }()
    
    var firstNameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
        field.placeholder = "First Name"
        return field
    }()
    
    var lastNameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
        field.placeholder = "Last Name"
        return field
    }()
    
    var emailField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Email"
        return field
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Password"
        return field
    }()
    
    var repeatPasswordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Repeat Password"
        return field
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(repeatPasswordField)
        view.addSubview(signUpButton)
        
        view.addConstraints([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            firstNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            firstNameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            firstNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 20),
            lastNameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            lastNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            emailField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            repeatPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            repeatPasswordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            repeatPasswordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            signUpButton.topAnchor.constraint(equalTo: repeatPasswordField.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    func presentSignUpError(_ message: String) {
        presentSimpleAlert(title: "Sign Up Error", message: message)
    }
    
    @objc func signUpButtonPressed() {
        guard firstNameField.hasText else {
            return presentSignUpError("First Name field is empty")
        }
        guard lastNameField.hasText else {
            return presentSignUpError("Last Name field is empty")
        }
        guard emailField.hasText, let email = emailField.text else {
            return presentSignUpError("Email field is empty")
        }
        guard passwordField.hasText, let password = passwordField.text else {
            return presentSignUpError("Password field is empty")
        }
        guard repeatPasswordField.text == password else {
            return presentSignUpError("Passwords do not match")
        }
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                self.presentSignUpError(error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
