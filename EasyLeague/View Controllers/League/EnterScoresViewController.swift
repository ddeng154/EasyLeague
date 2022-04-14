//
//  EnterScoresViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/8/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class EnterScoresViewController: UIViewController {
    
    var league: League!
    
    lazy var matchups = league.schedule[league.results.count].value
    
    lazy var tableView = createTable(for: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Enter Scores"
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(tableView)
        
        constrainToSafeArea(tableView)
    }

}

extension EnterScoresViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchups.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        var content = UIListContentConfiguration.cell()
        if indexPath.row < matchups.count {
            let matchup = matchups[indexPath.row]
            content.text = "\(league.teams[matchup.teamA].name) — \(league.teams[matchup.teamB].name)"
        } else {
            content.text = "Player Statistics"
        }
        content.textProperties.alignment = .center
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < matchups.count {
            
        } else {
            
        }
    }
    
}
