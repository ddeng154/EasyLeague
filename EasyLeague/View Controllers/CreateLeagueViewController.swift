//
//  CreateLeagueViewController.swift
//  EasyLeague
//
//  Created by Chen Zhou on 3/15/22.
//

import UIKit

class CreateLeagueViewController: UIViewController {

    lazy var nameField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.placeholder = "Ex: Basketball League"
        return withAutoLayout(field)
    }()
    
    lazy var numTeamField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.placeholder = "Ex: 25"
        return withAutoLayout(field)
    }()
    
    lazy var numMatchField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.placeholder = "Ex: 25"
        return withAutoLayout(field)
    }()
    
    lazy var tieBreakerField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.placeholder = "Ex: Rebounds"
        return withAutoLayout(field)
    }()
    
    lazy var createLeagueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create League", for: .normal)
        button.addTarget(self, action: #selector(createLeagueButtonPressed), for: .touchUpInside)
        return withAutoLayout(button)
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
        
        view.backgroundColor = .systemBackground

        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(numTeamField)
        stackView.addArrangedSubview(numMatchField)
        stackView.addArrangedSubview(tieBreakerField)
        stackView.addArrangedSubview(createLeagueButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }

    @objc func createLeagueButtonPressed() {
        let homeViewController = HomeViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true)
    }

}
