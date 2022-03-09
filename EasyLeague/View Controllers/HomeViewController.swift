//
//  HomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    var userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Auth.auth().currentUser?.email
        return label
    }()
    
    var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        view.addSubview(userLabel)
        view.addSubview(logOutButton)
        
        view.addConstraints([
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

