//
//  ProfileViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/31/22.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift
import CropViewController
import Kingfisher

class ProfileViewController: UIViewController {
    
    static let reuseIdentifier = "ProfileOptionsCell"
    
    var user: User!
    
    var userInterfaceStyle: UserInterfaceStyleWrapper!
    
    lazy var logOutButton = createCustomBarButton(title: "Log Out", action: #selector(logOutButtonPressed))
    
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
        navigationItem.rightBarButtonItem = logOutButton
        
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(profileCollection)
        
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
    
    func presentChangePhotoError(_ message: String) {
        presentSimpleAlert(title: "Change Photo Error", message: message)
    }

}

@objc extension ProfileViewController {
    
    func photoButtonPressed() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
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

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard !results.isEmpty else { return }
        let spinner = picker.addSpinner()
        results[0].itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                spinner.remove()
                if let image = image as? UIImage {
                    self.dismiss(animated: true) {
                        let cropController = CropViewController(croppingStyle: .circular, image: image)
                        cropController.delegate = self
                        cropController.cancelButtonHidden = false
                        cropController.rotateButtonsHidden = true
                        cropController.resetButtonHidden = true
                        cropController.doneButtonColor = .appAccent
                        cropController.modalPresentationStyle = .fullScreen
                        self.present(cropController, animated: true)
                    }
                } else if let error = error {
                    self.dismiss(animated: true)
                    self.presentChangePhotoError(error.localizedDescription)
                }
            }
        }
    }
    
}

extension ProfileViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        dismiss(animated: true)
        guard let photoData = image.pngData() else {
            return presentChangePhotoError("Profile picture cannot be converted to PNG")
        }
        let spinner = addSpinner()
        Task {
            do {
                let ref = Storage.storage().photoReferenceForUser(user.id)
                _ = try await ref.putDataAsync(photoData)
                let newURL = try await ref.downloadURL()
                let copy = try user.copy()
                copy.photoURL = newURL.absoluteString
                try Firestore.firestore().documentForUser(copy.id).setData(from: copy) { error in
                    spinner.remove()
                    if let error = error {
                        self.presentChangePhotoError(error.localizedDescription)
                    } else {
                        self.popFromNavigation()
                    }
                }
            } catch {
                spinner.remove()
                self.presentChangePhotoError(error.localizedDescription)
            }
        }
    }
    
}

