//
//  SignUpViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var delegate: SignUpStateChanger!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "EasyLeague"
        return withAutoLayout(label)
    }()
    
    lazy var firstNameField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
        field.placeholder = "First Name"
        return withAutoLayout(field)
    }()
    
    lazy var lastNameField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
        field.placeholder = "Last Name"
        return withAutoLayout(field)
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
    
    lazy var repeatPasswordField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Repeat Password"
        return withAutoLayout(field)
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
        stackView.addArrangedSubview(firstNameField)
        stackView.addArrangedSubview(lastNameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(repeatPasswordField)
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
    
    func presentSignUpError(_ message: String) {
        presentSimpleAlert(title: "Sign Up Error", message: message)
    }
    
    @objc func signUpButtonPressed() {
        guard firstNameField.hasText, let firstName = firstNameField.text else {
            return presentSignUpError("First Name field is empty")
        }
        guard lastNameField.hasText, let lastName = lastNameField.text else {
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
        let spinner = addSpinner()
        delegate.signUpStarted()
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                spinner.remove()
                self.delegate.signUpError()
                self.presentSignUpError(error.localizedDescription)
            } else if let user = result?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = "\(firstName) \(lastName)"
                changeRequest.commitChanges { _ in
                    spinner.remove()
                    self.delegate.signUpCompleted()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
