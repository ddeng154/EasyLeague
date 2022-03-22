//
//  CreateLeagueViewController.swift
//  EasyLeague
//
//  Created by Daniel Deng on 3/15/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class CreateLeagueViewController: UIViewController {

    lazy var leagueNameField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "League Name"
        return withAutoLayout(field)
    }()
    
    lazy var numTeamsField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Number of Teams"
        return withAutoLayout(field)
    }()
    
    lazy var numMatchesField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Number of Matches per Team"
        return withAutoLayout(field)
    }()
    
    lazy var createLeagueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create League", for: .normal)
        button.addTarget(self, action: #selector(createLeagueButtonPressed), for: .touchUpInside)
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

        stackView.addArrangedSubview(leagueNameField)
        stackView.addArrangedSubview(numTeamsField)
        stackView.addArrangedSubview(numMatchesField)
        stackView.addArrangedSubview(createLeagueButton)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func presentCreateLeagueError(_ message: String) {
        presentSimpleAlert(title: "Create League Error", message: message)
    }

    @objc func createLeagueButtonPressed() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return presentCreateLeagueError("Could not find current user")
        }
        guard leagueNameField.hasText, let leagueName = leagueNameField.text else {
            return presentCreateLeagueError("League Name field is empty")
        }
        guard numTeamsField.hasText, let numTeams = Int(numTeamsField.text), numTeams >= 2 else {
            return presentCreateLeagueError("Number of Teams must be a valid integer greater than or equal to 2")
        }
        guard numMatchesField.hasText, let numMatches = Int(numMatchesField.text), numMatches >= 1 else {
            return presentCreateLeagueError("Number of Matches must be a valid integer greater than or equal to 1")
        }
        let document = Firestore.firestore().leagueCollection.document()
        let league = League(id: document.documentID, ownerUserID: userID, memberUserIDs: [userID], name: leagueName, numTeams: numTeams, numMatches: numMatches)
        do {
            try document.setData(from: league)
            popFromNavigation()
        } catch {
            presentCreateLeagueError(error.localizedDescription)
        }
    }

}
