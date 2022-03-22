//
//  HomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController {

    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return withAutoLayout(label)
    }()
    
    lazy var userPhoto: UIImageView = {
        let image = UIImageView()
        return withAutoLayout(image)
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
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
        
        loadUserData()
        
        stackView.addArrangedSubview(userLabel)
        stackView.addArrangedSubview(userPhoto)
        stackView.addArrangedSubview(logOutButton)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func loadUserData() {
        if let user = Auth.auth().currentUser {
            userLabel.text = user.displayName
            user.storageReferenceForPhoto.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let data = data {
                    self.userPhoto.image = UIImage(data: data)
                }
            }
        }
    }

    @objc func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch {
            presentSimpleAlert(title: "Log Out Error", message: error.localizedDescription)
        }
    }

}

