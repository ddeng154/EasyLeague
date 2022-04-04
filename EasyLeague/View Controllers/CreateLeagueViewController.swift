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

    var user: User!

    lazy var leagueNameField = createTextField(placeholder: "League Name") { field in
        field.autocapitalizationType = .words
    }
    
    lazy var numTeamsField = createTextField(placeholder: "Number of Teams") { field in
        field.keyboardType = .numberPad
    }
    
    lazy var numMatchesField = createTextField(placeholder: "Number of Matches per Team") { field in
        field.keyboardType = .numberPad
    }
    
    lazy var createLeagueButton = createButton(title: "Create League", selector: #selector(createLeagueButtonPressed))
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "New League"

        stackView.addArrangedSubview(leagueNameField)
        stackView.addArrangedSubview(numTeamsField)
        stackView.addArrangedSubview(numMatchesField)
        stackView.addArrangedSubview(createLeagueButton)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentCreateLeagueError(_ message: String) {
        presentSimpleAlert(title: "Create League Error", message: message)
    }

}

@objc extension CreateLeagueViewController {
    
    func createLeagueButtonPressed() {
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
        let league = League(id: document.documentID, userID: user.uid, name: leagueName, numTeams: numTeams, numMatches: numMatches)
        do {
            try document.setData(from: league)
            popFromNavigation()
        } catch {
            presentCreateLeagueError(error.localizedDescription)
        }
    }
    
}
