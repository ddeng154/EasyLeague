//
//  JoinLeagueViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/30/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class JoinLeagueViewController: UIViewController {
    
    var user: User!
    
    lazy var doneButton = createBarButton(item: .done, selector: #selector(doneButtonPressed))
    
    lazy var leagueIDField = createTextField(placeholder: "League ID") { field in
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .center
    }
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Join League"
        navigationItem.rightBarButtonItem = doneButton
        
        stackView.addArrangedSubview(leagueIDField)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentJoinLeagueError(_ message: String) {
        presentSimpleAlert(title: "Join League Error", message: message)
    }

}

@objc extension JoinLeagueViewController {
    
    func doneButtonPressed() {
        guard leagueIDField.hasText, let leagueID = leagueIDField.text else {
            return presentJoinLeagueError("League ID field is empty")
        }
        let documentReference = Firestore.firestore().leagueCollection.document(leagueID)
        documentReference.getDocument(as: League.self) { result in
            switch result {
                case .success(let league):
                    guard !league.memberUserIDs.contains(self.user.id) else {
                        return self.presentJoinLeagueError("You are already in this League")
                    }
                    let alert = UIAlertController(title: nil, message: "Which team would you like to join?", preferredStyle: .actionSheet)
                    for team in league.teams {
                        alert.addAction(UIAlertAction(title: team.name, style: .default) { _ in
                            team.memberUserIDs.append(self.user.id)
                            league.memberUserIDs.append(self.user.id)
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
                case .failure(let error):
                    self.presentJoinLeagueError(error.localizedDescription)
            }
        }
    }
    
}
