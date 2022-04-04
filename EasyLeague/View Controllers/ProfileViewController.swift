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
    
    lazy var userLabel = createLabel(text: user.displayName)
    
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
    
    lazy var spacer = createSpacer()
    
    lazy var logOutButton = createButton(title: "Log Out", selector: #selector(logOutButtonPressed))
    
    lazy var stackView = createVerticalStack()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Profile"
        
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(logOutButton)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }

}

@objc extension ProfileViewController {
    
    func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch {
            presentSimpleAlert(title: "Log Out Error", message: error.localizedDescription)
        }
    }
    
}
