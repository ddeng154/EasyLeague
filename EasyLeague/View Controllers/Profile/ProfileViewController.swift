//
//  ProfileViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/31/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Kingfisher

class ProfileViewController: UIViewController {
    
    static let reuseIdentifier = "ProfileOptionsCell"
    
    var user: User!
    
    var userInterfaceStyle: UserInterfaceStyleWrapper!
    
    lazy var userLabel = createLabel() { label in
        label.font = .systemFont(ofSize: 25, weight: .semibold)
    }
    
    lazy var emailLabel = createLabel() { label in
        label.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    lazy var userLabelStack = createVerticalStack(for: [userLabel, emailLabel], spacing: 5, distribution: .fill, alignment: .leading)
    
    lazy var photoButton = createImageButton(action: #selector(photoButtonPressed), height: 70, width: 70)
    
    lazy var spacer = createSpacer()
    
    lazy var userStackView = createHorizontalStack(for: [photoButton, userLabelStack, spacer], spacing: 15, distribution: .fill, alignment: .center)
    
    lazy var overrideSystemAppearanceSwitch = createSwitch(action: #selector(overrideSystemAppearanceSwitchPressed))
    
    lazy var darkModeSwitch = createSwitch(action: #selector(darkModeSwitchPressed))
    
    lazy var options: [(name: String, swtch: UISwitch?, enabled: (() -> Bool)?, controller: (() -> UIViewController)?)] = [
        ("Change Name", nil, nil, {
            let controller = ChangeNameViewController()
            controller.user = self.user
            return controller
        }),
        ("Change Email", nil, nil, {
            let controller = ChangeEmailViewController()
            controller.user = self.user
            return controller
        }),
        ("Change Password", nil, nil, {
            let controller = ChangePasswordViewController()
            controller.user = self.user
            return controller
        }),
        ("Override System Appearance", overrideSystemAppearanceSwitch, nil, nil),
        ("Dark Mode", darkModeSwitch, { self.overrideSystemAppearanceSwitch.isOn },  nil),
    ]
    
    lazy var profileCollection = createCollection(for: self, reuseIdentifier: Self.reuseIdentifier, cellType: UICollectionViewListCell.self)
    
    lazy var logOutButton = createButton(title: "Log Out", action: #selector(logOutButtonPressed))
    
    lazy var stackView = createVerticalStack()
    
    var userListener: ListenerRegistration?
    
    deinit {
        userListener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Profile"
        
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(profileCollection)
        stackView.addArrangedSubview(logOutButton)
        
        updateDarkModeControls()
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
        
        addListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func reloadData() {
        userLabel.text = user.name
        emailLabel.text = Auth.auth().currentUser?.email
        photoButton.kf.setImage(with: URL(string: user.photoURL), for: .normal, placeholder: UIImage(systemName: "photo.circle"))
    }
    
    func configureLayout() {
        if let layout = profileCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: stackView.bounds.width - 15, height: 60)
            layout.minimumLineSpacing = 15
            layout.sectionInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        }
    }
    
    func addListener() {
        userListener = Firestore.firestore().userCollection.document(user.id).addSnapshotListener { documentSnapshot, _ in
            guard let snapshot = documentSnapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.user = user
            self.reloadData()
        }
    }
    
    func updateDarkModeControls() {
        let style = userInterfaceStyle.get()
        if style == .unspecified {
            overrideSystemAppearanceSwitch.setOn(false, animated: false)
            darkModeSwitch.setOn(false, animated: false)
        } else {
            overrideSystemAppearanceSwitch.setOn(true, animated: false)
            darkModeSwitch.setOn(style == .dark, animated: false)
        }
        profileCollection.reloadData()
    }

}

@objc extension ProfileViewController {
    
    func photoButtonPressed() {
        
    }
    
    func overrideSystemAppearanceSwitchPressed() {
        if overrideSystemAppearanceSwitch.isOn {
            userInterfaceStyle.set(.light)
        } else {
            userInterfaceStyle.set(.unspecified)
        }
        updateDarkModeControls()
    }
    
    func darkModeSwitchPressed() {
        if darkModeSwitch.isOn {
            userInterfaceStyle.set(.dark)
        } else {
            userInterfaceStyle.set(.light)
        }
    }
    
    func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch {
            presentSimpleAlert(title: "Log Out Error", message: error.localizedDescription)
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath)
        guard let cell = cell as? UICollectionViewListCell else { return cell }
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 1, height: 2)
        cell.layer.shadowRadius = 3
        
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = .systemGray6
        background.cornerRadius = 15
        cell.backgroundConfiguration = background
        
        var content = cell.defaultContentConfiguration()
        let data = options[indexPath.row]
        content.text = data.name
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.contentConfiguration = content
        
        if let swtch = data.swtch {
            cell.accessories = []
            cell.contentView.addSubview(swtch)
            swtch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            swtch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20).isActive = true
        } else {
            cell.accessories = [.disclosureIndicator()]
        }
        
        if let enabled = data.enabled?() {
            cell.isUserInteractionEnabled = enabled
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let controller = self.options[indexPath.row].controller?() {
            show(controller, sender: self)
        }
    }
    
}

