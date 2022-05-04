//
//  EnterMatchupResultsViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

import UIKit

class EnterMatchupResultsViewController: UIViewController {
    
    var league: League!
    
    var matchup: Matchup!
    
    var completion: ((_ outcome: Outcome, _ teamA: (i: Int, stats: [String : Int]), _ teamB: (i: Int, stats: [String : Int]), _ playerStats: [String : [String : Int]]) -> Void)!
    
    lazy var teamStatNames = league.teamStats.keys.sorted()
    
    lazy var playerStatNames = league.playerStats.keys.sorted()
    
    lazy var teamAStats = teamStatNames.map { _ in
        createTextField(placeholder: "0", height: 30) { field in
            field.keyboardType = .numberPad
            field.textAlignment = .right
        }
    }
    
    lazy var teamBStats = teamStatNames.map { _ in
        createTextField(placeholder: "0", height: 30) { field in
            field.keyboardType = .numberPad
            field.textAlignment = .right
        }
    }
    
    lazy var playersAStats: [(info: (id: String, name: String), stats: [UITextField])] = league.teams[matchup.teamA].memberUserIDs.compactMap { id in
        guard let user = Shared.userMap[id] else { return nil }
        return ((user.id, user.name), playerStatNames.map { statName in
            createTextField(placeholder: "0", height: 30) { field in
                field.keyboardType = .numberPad
                field.textAlignment = .right
            }
        })
    }
    
    lazy var playersBStats: [(info: (id: String, name: String), stats: [UITextField])] = league.teams[matchup.teamB].memberUserIDs.compactMap { id in
        guard let user = Shared.userMap[id] else { return nil }
        return ((user.id, user.name), playerStatNames.map { statName in
            createTextField(placeholder: "0", height: 30) { field in
                field.keyboardType = .numberPad
                field.textAlignment = .right
            }
        })
    }
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))
    
    lazy var winnerLabel = createLabel(text: "Select Winner") { label in
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    lazy var winnerControl = createSegmentedControl(items: [league.teams[matchup.teamA].name, league.teams[matchup.teamB].name])
    
    lazy var tiedControl = createSegmentedControl(items: [league.teams[matchup.teamA].name, "Tie", league.teams[matchup.teamB].name])
    
    lazy var winnerStack = league.allowTies ? createVerticalStack(for: [winnerLabel, tiedControl], spacing: 10) : createVerticalStack(for: [winnerLabel, winnerControl], spacing: 10)
    
    lazy var tableView = createTable(for: self) { table in
        table.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tableTapRecognized)))
    }
    
    lazy var stackView = createVerticalStack(spacing: 15)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Matchup Results"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton
        
        stackView.addArrangedSubview(winnerStack)
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentEnterResultsError(_ message: String) {
        presentSimpleAlert(title: "Enter Results Error", message: message)
    }
    
    func presentTeamStatsError() {
        presentEnterResultsError("Please enter a valid integer for all team statistics")
    }
    
    func presentPlayerStatsError() {
        presentEnterResultsError("Please enter a valid integer for all player statistics")
    }

}

@objc extension EnterMatchupResultsViewController {
    
    func doneButtonPressed() {
        let teamStatsA = teamAStats.compactMap { field in Int(field.text) }
        guard teamStatsA.count == teamStatNames.count else { return self.presentTeamStatsError() }
        
        let teamStatsB = teamBStats.compactMap { field in Int(field.text) }
        guard teamStatsB.count == teamStatNames.count else { return self.presentTeamStatsError() }
        
        let playerStatsA = playersAStats.map { (info, stats) in (info, stats.compactMap { field in Int(field.text) }) }
        guard playerStatsA.allSatisfy({ (_, stats) in stats.count == playerStatNames.count }) else { return self.presentPlayerStatsError() }
        
        let playerStatsB = playersBStats.map { (info, stats) in (info, stats.compactMap { field in Int(field.text) }) }
        guard playerStatsB.allSatisfy({ (_, stats) in stats.count == playerStatNames.count }) else { return self.presentPlayerStatsError() }
        
        var playerStats: [String : [String : Int]] = Dictionary(uniqueKeysWithValues: playerStatNames.map { name in (name, [:]) })
        for ((id, _), stats) in playerStatsA + playerStatsB {
            for i in stats.indices {
                playerStats[playerStatNames[i], default: [:]][id] = stats[i]
            }
        }
        
        let statsA: [String : Int] = Dictionary(uniqueKeysWithValues: teamStatsA.indices.map { i in (teamStatNames[i], teamStatsA[i]) })
        let statsB: [String : Int] = Dictionary(uniqueKeysWithValues: teamStatsB.indices.map { i in (teamStatNames[i], teamStatsB[i]) })
        
        let outcome: Outcome
        if league.allowTies {
            if tiedControl.selectedSegmentIndex == 0 {
                outcome = Outcome(winner: matchup.teamA, loser: matchup.teamB, tiedA: -1, tiedB: -1)
            } else if tiedControl.selectedSegmentIndex == 1 {
                outcome = Outcome(winner: -1, loser: -1, tiedA: matchup.teamA, tiedB: matchup.teamB)
            } else {
                outcome = Outcome(winner: matchup.teamB, loser: matchup.teamA, tiedA: -1, tiedB: -1)
            }
        } else {
            if winnerControl.selectedSegmentIndex == 0 {
                outcome = Outcome(winner: matchup.teamA, loser: matchup.teamB, tiedA: -1, tiedB: -1)
            } else {
                outcome = Outcome(winner: matchup.teamB, loser: matchup.teamA, tiedA: -1, tiedB: -1)
            }
        }
        
        completion(outcome, (matchup.teamA, statsA), (matchup.teamB, statsB), playerStats)
        popFromNavigation()
    }
    
    func tableTapRecognized() {
        view.endEditing(true)
    }
    
}

extension EnterMatchupResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    enum Location {
        case teamA
        case teamB
        case playersA(Int)
        case playersB(Int)
    }
    
    func location(_ num: Int) -> Location? {
        switch num {
            case 0:
                return .teamA
            case 1:
                return .teamB
            case 2..<(2 + playersAStats.count):
                return .playersA(num - 2)
            case (2 + playersAStats.count)..<(2 + playersAStats.count + playersBStats.count):
                return .playersB(num - playersAStats.count - 2)
            default:
                return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2 + playersAStats.count + playersBStats.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let location = location(section) else { return nil }
        let title: String
        switch location {
            case .teamA:
                title = league.teams[matchup.teamA].name
            case .teamB:
                title = league.teams[matchup.teamB].name
            case .playersA(let ind):
                title = playersAStats[ind].info.name
            case .playersB(let ind):
                title = playersBStats[ind].info.name
        }
        return "\(title) Statistics"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch location(section) {
            case .teamA, .teamB:
                return teamStatNames.count
            case .playersA, .playersB:
                return playerStatNames.count
            case nil:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let location = location(indexPath.section) else { return cell }
        let labelText: String
        let field: UITextField
        switch location {
            case .teamA:
                labelText = teamStatNames[indexPath.row]
                field = teamAStats[indexPath.row]
            case .teamB:
                labelText = teamStatNames[indexPath.row]
                field = teamBStats[indexPath.row]
            case .playersA(let ind):
                labelText = playerStatNames[indexPath.row]
                field = playersAStats[ind].stats[indexPath.row]
            case .playersB(let ind):
                labelText = playerStatNames[indexPath.row]
                field = playersBStats[ind].stats[indexPath.row]
        }
        let label = createLabel(text: labelText)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        let stack = createHorizontalStack(for: [label, field], distribution: .fillEqually, alignment: .center)
        cell.contentView.addSubview(stack)
        constrainToSafeArea(stack, superview: cell.contentView)
        return cell
    }
    
}
