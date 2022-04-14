//
//  ProfileViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/31/22.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    static let reuseIdentifier = "ProfileCell"
    
    var user: User!
    
    var userInterfaceStyle: UserInterfaceStyleWrapper!
    
    lazy var userLabel = createLabel(text: user.name) { label in
        label.font = .systemFont(ofSize: 25, weight: .semibold)
    }
    
    lazy var emailLabel = createLabel() { label in
        label.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    lazy var userLabelStack = createVerticalStack(for: [userLabel, emailLabel], spacing: 5, distribution: .fill, alignment: .leading)
    
    lazy var userPhoto = createImageView { imageView in
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.kf.setImage(with: URL(string: self.user.photoURL), placeholder: UIImage(systemName: "photo.circle"))
    }
    
    lazy var spacer = createSpacer()
    
    lazy var userStackView = createHorizontalStack(for: [userPhoto, userLabelStack, spacer], spacing: 15, distribution: .fill, alignment: .center)
    
    lazy var updateEmailLabel = createLabel(text: "Update Email Address") { label in
        label.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    lazy var updatePasswordLabel = createLabel(text: "Change Password") { label in
        label.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    lazy var updateEmailView = createHorizontalStack(for: [updateEmailLabel])
    
    lazy var updatePasswordView = createHorizontalStack(for: [updatePasswordLabel])
    
    lazy var overrideSystemAppearanceLabel = createLabel(text: "Override System Appearance") { label in
        label.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    lazy var overrideSystemAppearanceSwitch = createSwitch(action: #selector(overrideSystemAppearanceSwitchPressed))
    
    lazy var overrideSystemAppearanceStackView = createHorizontalStack(for: [overrideSystemAppearanceLabel, overrideSystemAppearanceSwitch])
    
    lazy var darkModeLabel = createLabel(text: "Dark Mode") { label in
        label.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    lazy var darkModeSwitch = createSwitch(action: #selector(darkModeSwitchPressed))
    
    lazy var darkModeStackView = createHorizontalStack(for: [darkModeLabel, darkModeSwitch])
    
    lazy var profileStacks = [updateEmailView, updatePasswordView, overrideSystemAppearanceStackView]
    
    lazy var profileCollection = createCollection(for: self, reuseIdentifier: Self.reuseIdentifier, cellType: UICollectionViewListCell.self)
    
    lazy var logOutButton = createButton(title: "Log Out", action: #selector(logOutButtonPressed))
    
    lazy var stackView = createVerticalStack()

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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func configureLayout() {
        if let layout = profileCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: profileCollection.bounds.width - 15, height: 70)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        }
    }
    
    func updateDarkModeControls() {
        let style = userInterfaceStyle.get()
        if style == .unspecified {
            overrideSystemAppearanceSwitch.setOn(false, animated: false)
            if profileStacks.count == 4 {
                profileStacks.removeLast()
                darkModeStackView.removeFromSuperview()
            }
        } else {
            overrideSystemAppearanceSwitch.setOn(true, animated: false)
            if profileStacks.count < 4 {
                profileStacks.append(darkModeStackView)
            }
            darkModeSwitch.setOn(style == .dark, animated: false)
        }
        profileCollection.reloadData()
    }

}

@objc extension ProfileViewController {
    
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
        profileStacks.count
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
        
        let stack = profileStacks[indexPath.row]
        if stack === updateEmailView || stack === updatePasswordView {
            cell.accessories = [.disclosureIndicator()]
        } else {
            cell.accessories = []
        }
        cell.contentView.addSubview(stack)
        constrainToSafeArea(stack, superview: cell.contentView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let stack = profileStacks[indexPath.row]
        if stack === updateEmailView {
            let updateEmailController = UpdateEmailViewController()
            updateEmailController.user = user
            show(updateEmailController, sender: self)
        } else if stack === updatePasswordView {
            let changePasswordController = ChangePasswordViewController()
            changePasswordController.user = user
            show(changePasswordController, sender: self)
        }
    }
    
}

