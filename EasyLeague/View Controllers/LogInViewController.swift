//
//  LogInViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    var delegate: SignUpStateChanger!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "EasyLeague"
        return withAutoLayout(label)
    }()
    
    lazy var emailField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Email"
        return withAutoLayout(field)
    }()
    
    lazy var passwordField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Password"
        return withAutoLayout(field)
    }()
    
    lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        return withAutoLayout(button)
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return withAutoLayout(button)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(logInButton)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            logInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            logInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    func presentLogInError(_ message: String) {
        presentSimpleAlert(title: "Log In Error", message: message)
    }
    
    @objc func logInButtonPressed() {
        guard emailField.hasText, let email = emailField.text else {
            return presentLogInError("Email field is empty")
        }
        guard passwordField.hasText, let password = passwordField.text else {
            return presentLogInError("Password field is empty")
        }
        let spinner = addSpinner()
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            spinner.remove()
            if let error = error {
                self.presentLogInError(error.localizedDescription)
            }
        }
    }
    
    @objc func signUpButtonPressed() {
        let signUpController = SignUpViewController()
        signUpController.delegate = delegate
        show(signUpController, sender: self)
    }
    
}
