//
//  SignUpViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift
import CropViewController

class SignUpViewController: UIViewController {
    
    var authStateChanger: AuthStateChanger!
    
    var profilePicture: UIImage?
    
    lazy var titleLabel = createLabel(text: "EasyLeague") { label in
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
    }
    
    lazy var firstNameField = createTextField(placeholder: "First Name") { field in
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
    }
    
    lazy var lastNameField = createTextField(placeholder: "Last Name") { field in
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
    }
    
    lazy var emailField = createTextField(placeholder: "Email") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.keyboardType = .emailAddress
    }
    
    lazy var passwordField = createTextField(placeholder: "Password") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
    }
    
    lazy var repeatPasswordField = createTextField(placeholder: "Repeat Password") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
    }
    
    lazy var photoPickerButton = createButton(title: "Choose Profile Picture", action: #selector(photoPickerButtonPressed))
    
    lazy var signUpButton = createButton(title: "Sign Up", action: #selector(signUpButtonPressed))
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(firstNameField)
        stackView.addArrangedSubview(lastNameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(repeatPasswordField)
        stackView.addArrangedSubview(photoPickerButton)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentSignUpError(_ message: String) {
        presentSimpleAlert(title: "Sign Up Error", message: message)
    }
    
}

@objc extension SignUpViewController {
    
    func photoPickerButtonPressed() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func signUpButtonPressed() {
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
        guard let profilePicture = profilePicture else {
            return presentSignUpError("Profile picture is not selected")
        }
        guard let photoData = profilePicture.pngData() else {
            return presentSignUpError("Profile picture cannot be converted to PNG")
        }
        let spinner = addSpinner()
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                spinner.remove()
                self.presentSignUpError(error.localizedDescription)
            } else if let firebaseUser = result?.user {
                Task {
                    do {
                        let ref = Storage.storage().photoReferenceForUser(firebaseUser.uid)
                        _ = try await ref.putDataAsync(photoData)
                        let photoURL = try await ref.downloadURL()
                        let user = User(id: firebaseUser.uid, name: "\(firstName) \(lastName)", photoURL: photoURL.absoluteString)
                        try Firestore.firestore().documentForUser(user.id).setData(from: user) { error in
                            if let error = error {
                                firebaseUser.delete()
                                spinner.remove()
                                self.presentSignUpError(error.localizedDescription)
                            } else {
                                spinner.remove()
                                self.dismiss(animated: true)
                                self.authStateChanger.authenticated(user: user)
                            }
                        }
                    } catch {
                        try? await firebaseUser.delete()
                        spinner.remove()
                        self.presentSignUpError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}

extension SignUpViewController: PHPickerViewControllerDelegate {
    
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
                        cropController.cancelButtonHidden = true
                        cropController.rotateButtonsHidden = true
                        cropController.resetButtonHidden = true
                        cropController.doneButtonColor = .appAccent
                        cropController.modalPresentationStyle = .currentContext
                        self.present(cropController, animated: true)
                    }
                } else if let error = error {
                    self.dismiss(animated: true)
                    self.presentSignUpError(error.localizedDescription)
                }
            }
        }
    }
    
}

extension SignUpViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        dismiss(animated: true)
        profilePicture = image
    }
    
}
