//
//  EditLeagueViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class EditLeagueViewController: UIViewController {
    
    var user: User!
    
    var league: League!
    
    var team: Team!
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))
    
    lazy var leagueNameField = createTextField(placeholder: "New League Name") { field in
        field.autocapitalizationType = .words
    }
    
    lazy var teamNameField = createTextField(placeholder: "New Team Name") { field in
        field.autocapitalizationType = .words
    }
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Edit League"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton
        
        if user.id == league.ownerUserID {
            stackView.addArrangedSubview(leagueNameField)
        }
        stackView.addArrangedSubview(teamNameField)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentEditLeagueError(_ message: String) {
        presentSimpleAlert(title: "Edit League Error", message: message)
    }
    
}

@objc extension EditLeagueViewController {
    
    func doneButtonPressed() {
        let leagueName = leagueNameField.hasText ? leagueNameField.text : nil
        let teamName = teamNameField.hasText ? teamNameField.text : nil
        guard leagueName != nil || teamName != nil else {
            return popFromNavigation()
        }
        do {
            let copy = try league.copy()
            if let leagueName = leagueName {
                copy.name = leagueName
            }
            if let teamName = teamName {
                copy.teams[team.index].name = teamName
            }
            try Firestore.firestore().leagueCollection.document(copy.id).setData(from: copy) { error in
                if let error = error {
                    self.presentEditLeagueError(error.localizedDescription)
                } else {
                    self.popFromNavigation()
                }
            }
        } catch {
            self.presentEditLeagueError(error.localizedDescription)
        }
    }
    
}
