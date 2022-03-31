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
    
    lazy var leagueIDField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .center
        field.placeholder = "League ID"
        return withAutoLayout(field)
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
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
        
        navigationItem.title = "Join League"
        
        stackView.addArrangedSubview(leagueIDField)
        stackView.addArrangedSubview(confirmButton)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func presentJoinLeagueError(_ message: String) {
        presentSimpleAlert(title: "Join League Error", message: message)
    }
    
    @objc func confirmButtonPressed() {
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
