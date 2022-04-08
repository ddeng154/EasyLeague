//
//  LeagueInfoViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/31/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class LeagueInfoViewController: UIViewController {
    
    var league: League!
    
    var users: [String : User] = [:]
    
    lazy var teamsTable = createTable(for: self)
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        navigationItem.title = league.name
        
        stackView.addArrangedSubview(teamsTable)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            let spinner = addSpinner()
            for memberID in league.memberUserIDs {
                users[memberID] = try? await Firestore.firestore().documentForUser(memberID).getDocument(as: User.self)
            }
            teamsTable.reloadData()
            spinner.remove()
        }
    }
    
}

extension LeagueInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        league.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.valueCell()
        content.text = league.teams[indexPath.row].name
        content.secondaryText = league.teams[indexPath.row].memberUserIDs.compactMap { memberID in users[memberID]?.name }.joined(separator: "\n")
        content.prefersSideBySideTextAndSecondaryText = false
        content.textProperties.alignment = .center
        content.secondaryTextProperties.alignment = .center
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
