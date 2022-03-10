//
//  HomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.text = Auth.auth().currentUser?.displayName
        return withAutoLayout(label)
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        return withAutoLayout(button)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        view.addSubview(userLabel)
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            logOutButton.topAnchor.constraint(equalTo: userLabel.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            logOutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }

    @objc func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch {
            presentSimpleAlert(title: "Log Out Error", message: error.localizedDescription)
        }
    }

}

