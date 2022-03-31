//
//  LogInViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    var authStateChanger: AuthStateChanger!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
        field.isSecureTextEntry = true
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
    
    lazy var spacer: UIView = {
        let spacer = UIView()
        return spacer
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 20
        return withAutoLayout(stack)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(logInButton)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            spinner.remove()
            if let error = error {
                self.presentLogInError(error.localizedDescription)
            } else if let result = result {
                self.authStateChanger.authenticated(user: result.user)
            }
        }
    }
    
    @objc func signUpButtonPressed() {
        let signUpController = SignUpViewController()
        signUpController.authStateChanger = authStateChanger
        show(signUpController, sender: self)
    }
    
}
