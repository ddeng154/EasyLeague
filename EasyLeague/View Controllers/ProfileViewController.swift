//
//  ProfileViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/31/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var user: User!
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.text = user.displayName
        return withAutoLayout(label)
    }()
    
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo.circle"))
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        user.storageReferenceForPhoto.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let data = data {
                imageView.image = UIImage(data: data)
            }
        }
        return withAutoLayout(imageView)
    }()
    
    lazy var userStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userLabel, userPhoto])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        return withAutoLayout(stack)
    }()
    
    lazy var spacer: UIView = {
        let spacer = UIView()
        return spacer
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
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

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Profile"
        
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(logOutButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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
