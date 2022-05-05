//
//  StandingsViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

import UIKit

class StandingsViewController: UIViewController {
    
    var league: League!
    
    lazy var standings: [(team: String, wins: Int, losses: Int, ties: Int)] = {
        var standings: [(team: String, wins: Int, losses: Int, ties: Int)] = league.teams.map { team in (team.name, 0, 0, 0) }
        for outcomes in league.results {
            for outcome in outcomes.value {
                if let result = outcome.winResults {
                    standings[result.winner].wins += 1
                    standings[result.loser].losses += 1
                } else if let result = outcome.tieResults {
                    standings[result.teamA].ties += 1
                    standings[result.teamB].ties += 1
                }
            }
        }
        return standings.sorted { lhs, rhs in lhs.wins == rhs.wins ? lhs.ties > rhs.ties : lhs.wins > rhs.wins }
    }()
    
    lazy var nameLabel = createLabel(text: "    Name") { label in
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var recordLabel = createLabel(text: league.allowTies ? "W - T - L   " : "W - L    ") { label in
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var headerStack = createHorizontalStack(for: [nameLabel, recordLabel])
    
    lazy var standingsTable = createTable(for: self)
    
    lazy var stackView = createVerticalStack()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Standings"
        navigationItem.largeTitleDisplayMode = .never
        
        stackView.addArrangedSubview(headerStack)
        stackView.addArrangedSubview(standingsTable)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }

}

extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        standings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.valueCell()
        let data = standings[indexPath.row]
        content.text = standings[indexPath.row].team
        content.secondaryText = league.allowTies ? "\(data.wins) - \(data.ties) - \(data.losses)" : "\(data.wins) - \(data.losses)"
        content.textProperties.font = .systemFont(ofSize: 15, weight: .semibold)
        content.secondaryTextProperties.font = .systemFont(ofSize: 15, weight: .light)
        cell.contentConfiguration = content
        return cell
    }

}
