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
    
    lazy var teamsTable = createTable(for: self)
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Info"
        
        stackView.addArrangedSubview(teamsTable)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
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
        content.secondaryText = league.teams[indexPath.row].memberUserIDs.compactMap { memberID in Shared.userMap[memberID]?.name }.joined(separator: "\n")
        content.prefersSideBySideTextAndSecondaryText = false
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        content.textProperties.alignment = .center
        content.secondaryTextProperties.alignment = .center
        cell.contentConfiguration = content
        cell.backgroundColor = .appBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
