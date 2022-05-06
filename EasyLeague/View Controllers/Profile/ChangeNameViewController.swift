//
//  ChangeNameViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 5/5/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChangeNameViewController: UIViewController {
    
    var user: User!
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))
    
    lazy var firstNameField = createTextField(placeholder: "New First Name") { field in
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
    }
    
    lazy var lastNameField = createTextField(placeholder: "New Last Name") { field in
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
    }
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Change Name"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton
        
        stackView.addArrangedSubview(firstNameField)
        stackView.addArrangedSubview(lastNameField)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentChangeNameError(_ message: String) {
        presentSimpleAlert(title: "Change Name Error", message: message)
    }

}

@objc extension ChangeNameViewController {
    
    func doneButtonPressed() {
        guard firstNameField.hasText, let firstName = firstNameField.text else {
            return presentChangeNameError("First Name field is empty")
        }
        guard lastNameField.hasText, let lastName = lastNameField.text else {
            return presentChangeNameError("Last Name field is empty")
        }
        let spinner = addSpinner()
        do {
            let copy = try user.copy()
            copy.name = "\(firstName) \(lastName)"
            try Firestore.firestore().userCollection.document(copy.id).setData(from: copy) { error in
                if let error = error {
                    spinner.remove()
                    self.presentChangeNameError(error.localizedDescription)
                } else {
                    self.popFromNavigation()
                }
            }
        } catch {
            spinner.remove()
            self.presentChangeNameError(error.localizedDescription)
        }
    }
    
}
