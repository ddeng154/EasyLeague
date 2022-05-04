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
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))
    
    lazy var matchups = league.schedule[league.results.count].value
    
    lazy var outcomes: [Outcome?] = Array(repeating: nil, count: matchups.count)
    
    lazy var leagueTeamStats = league.teamStats
    
    lazy var leaguePlayerStats = league.playerStats
    
    lazy var tableView = createTable(for: self, allowsSelection: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Enter Scores"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton
        
        view.addSubview(tableView)
        
        constrainToSafeArea(tableView)
    }
    
    func presentEnterScoresError(_ message: String) {
        presentSimpleAlert(title: "Enter Scores Error", message: message)
    }

}

@objc extension EnterScoresViewController {
    
    func doneButtonPressed() {
        let completedOutcomes = outcomes.compactMap { o in o }
        guard completedOutcomes.count == outcomes.count else {
            return presentEnterScoresError("Please enter scores for all matchups")
        }
        do {
            let copy = try league.copy()
            copy.results.append(Outcomes(value: completedOutcomes))
            copy.teamStats = leagueTeamStats
            copy.playerStats = leaguePlayerStats
            try Firestore.firestore().leagueCollection.document(copy.id).setData(from: copy) { error in
                if let error = error {
                    self.presentEnterScoresError(error.localizedDescription)
                } else {
                    self.popFromNavigation()
                }
            }
        } catch {
            self.presentEnterScoresError(error.localizedDescription)
        }
    }
    
}

extension EnterScoresViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if outcomes[indexPath.row] != nil {
            cell.accessoryType = .checkmark
            cell.isUserInteractionEnabled = false
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        let matchup = matchups[indexPath.row]
        var content = UIListContentConfiguration.cell()
        content.text = "\(league.teams[matchup.teamA].name) — \(league.teams[matchup.teamB].name)"
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
        let controller = EnterMatchupResultsViewController()
        controller.league = league
        controller.matchup = matchups[indexPath.row]
        controller.completion = { (outcome, teamA, teamB, playerStats) in
            let (aInd, aStats) = teamA
            let (bInd, bStats) = teamB
            for (stat, val) in aStats {
                self.leagueTeamStats[stat]?[aInd] += val
            }
            for (stat, val) in bStats {
                self.leagueTeamStats[stat]?[bInd] += val
            }
            for (stat, stats) in playerStats {
                for (player, val) in stats {
                    self.leaguePlayerStats[stat]?[player, default: 0] += val
                }
            }
            self.outcomes[indexPath.row] = outcome
            tableView.reloadData()
        }
        show(controller, sender: self)
    }
    
}
