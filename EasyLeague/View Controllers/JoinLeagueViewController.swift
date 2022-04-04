//
//  JoinLeagueViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/30/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class JoinLeagueViewController: UIViewController {
    
    var user: User!
    
    lazy var leagueIDField = createTextField(placeholder: "League ID") { field in
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .center
    }
    
    lazy var confirmButton = createButton(title: "Confirm", selector: #selector(confirmButtonPressed))
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Join League"
        
        stackView.addArrangedSubview(leagueIDField)
        stackView.addArrangedSubview(confirmButton)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentJoinLeagueError(_ message: String) {
        presentSimpleAlert(title: "Join League Error", message: message)
    }

}

@objc extension JoinLeagueViewController {
    
    func confirmButtonPressed() {
        guard leagueIDField.hasText, let leagueID = leagueIDField.text else {
            return presentJoinLeagueError("League ID field is empty")
        }
        let documentReference = Firestore.firestore().leagueCollection.document(leagueID)
        documentReference.getDocument { snapshot, error in
            if let error = error {
                self.presentJoinLeagueError(error.localizedDescription)
            } else if let snapshot = snapshot {
                guard let league = try? snapshot.data(as: League.self) else {
                    return self.presentJoinLeagueError("Could not find League")
                }
                guard !league.memberUserIDs.contains(self.user.uid) else {
                    return self.presentJoinLeagueError("You are already in this League")
                }
                let alert = UIAlertController(title: nil, message: "Which team would you like to join?", preferredStyle: .actionSheet)
                for team in league.teams {
                    alert.addAction(UIAlertAction(title: team.name, style: .default) { _ in
                        team.memberUserIDs.append(self.user.uid)
                        league.memberUserIDs.append(self.user.uid)
                        do {
                            try documentReference.setData(from: league) { error in
                                if let error = error {
                                    self.presentJoinLeagueError(error.localizedDescription)
                                } else {
                                    self.popFromNavigation()
                                }
                            }
                        } catch {
                            self.presentJoinLeagueError(error.localizedDescription)
                        }
                    })
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }
    
}
