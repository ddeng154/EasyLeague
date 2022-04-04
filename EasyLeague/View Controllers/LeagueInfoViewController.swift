//
//  LeagueInfoViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/31/22.
//

import UIKit

class LeagueInfoViewController: UIViewController {
    
    var league: League!
    
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
    
}

extension LeagueInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        league.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.valueCell()
        content.text = league.teams[indexPath.row].name
        content.secondaryText = league.teams[indexPath.row].memberUserIDs.joined(separator: "\n")
        content.prefersSideBySideTextAndSecondaryText = false
        content.textProperties.alignment = .center
        content.secondaryTextProperties.alignment = .center
        cell.contentConfiguration = content
        return cell
    }
    
}
