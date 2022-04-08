//
//  Extensions.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/7/22.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func addSpinner() -> SpinnerViewController {
        let spinner = SpinnerViewController()
        add(spinner)
        return spinner
    }
    
    func withAutoLayout<V: UIView>(_ subview: V) -> V {
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }
    
    func popFromNavigation() {
        navigationController?.popViewController(animated: true)
    }
    
    func constrainToSafeArea(_ subview: UIView) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            subview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            subview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func createSpacer() -> UIView {
        let spacer = UIView()
        return withAutoLayout(spacer)
    }
    
    func createVerticalStack(spacing: CGFloat = 20) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = spacing
        return withAutoLayout(stack)
    }
    
    func createLabel(text: String? = nil, customize: ((UILabel) -> Void)? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        customize?(label)
        return withAutoLayout(label)
    }
    
    func createTextField(placeholder: String? = nil, customize: ((UITextField) -> Void)? = nil) -> UITextField {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = placeholder
        field.delegate = self
        customize?(field)
        return withAutoLayout(field)
    }
    
    func createButton(title: String, selector: Selector, customize: ((UIButton) -> Void)? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        customize?(button)
        return withAutoLayout(button)
    }
    
    func createTable(for vc: UITableViewDelegate & UITableViewDataSource) -> UITableView {
        let tableView = UITableView()
        tableView.delegate = vc
        tableView.dataSource = vc
        return withAutoLayout(tableView)
    }
    
}

extension Firestore {
    
    var leagueCollection: CollectionReference {
        collection("leagues")
    }
    
    func leaguesQueryForUser(_ id: String) -> Query {
        leagueCollection.whereField("memberUserIDs", arrayContains: id)
    }
    
    var userCollection: CollectionReference {
        collection("users")
    }
    
    func documentForUser(_ id: String) -> DocumentReference {
        userCollection.document(id)
    }
    
}

extension Storage {
    
    func photoReferenceForUser(_ id: String) -> StorageReference {
        reference().child("photos").child("\(id).png")
    }
    
}

extension Int {
    
    init?(_ description: String?) {
        guard let description = description else { return nil }
        self.init(description)
    }
    
}
