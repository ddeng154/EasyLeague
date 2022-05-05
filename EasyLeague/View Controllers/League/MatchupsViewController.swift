//
//  MatchupsViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

import UIKit

class MatchupsViewController: UIViewController {
    
    enum Result {
        case win, loss, tie, upcoming
    }
    
    var league: League!
    
    var team: Team!
    
    lazy var matchups: [(team: String, results: [(opponent: String, result: Result)])] = {
        var matchups: [(team: String, results: [(opponent: String, result: Result)])] = league.teams.map { team in (team.name, []) }
        for outcomes in league.results {
            for outcome in outcomes.value {
                if let result = outcome.winResults {
                    matchups[result.winner].results.append((matchups[result.loser].team, .win))
                    matchups[result.loser].results.append((matchups[result.winner].team, .loss))
                } else if let result = outcome.tieResults {
                    matchups[result.teamA].results.append((matchups[result.teamB].team, .tie))
                    matchups[result.teamB].results.append((matchups[result.teamA].team, .tie))
                }
            }
        }
        for leagueMatchups in league.schedule[league.results.count...] {
            for matchup in leagueMatchups.value {
                matchups[matchup.teamA].results.append((matchups[matchup.teamB].team, .upcoming))
                matchups[matchup.teamB].results.append((matchups[matchup.teamA].team, .upcoming))
            }
        }
        return matchups
    }()
    
    lazy var teamPicker = createPicker(for: self, selectedRow: self.team.index)
    
    lazy var opponentLabel = createLabel(text: "    Opponent") { label in
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var resultLabel = createLabel(text: "Result    ") { label in
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var headerStack = createHorizontalStack(for: [opponentLabel, resultLabel])
    
    lazy var matchupsTable = createTable(for: self)
    
    lazy var stackView = createVerticalStack()
    
    var teamMatchups: [(opponent: String, result: Result)] {
        matchups[teamPicker.selectedRow(inComponent: 0)].results
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Matchups"
        navigationItem.largeTitleDisplayMode = .never
        
        stackView.addArrangedSubview(teamPicker)
        stackView.addArrangedSubview(headerStack)
        stackView.addArrangedSubview(matchupsTable)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }

}

extension MatchupsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        matchups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        matchups[row].team
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        matchupsTable.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40
    }
    
}

extension MatchupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teamMatchups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.valueCell()
        content.text = "\(indexPath.row + 1).\t\(teamMatchups[indexPath.row].opponent)"
        content.textProperties.font = .systemFont(ofSize: 15, weight: .medium)
        content.secondaryTextProperties.font = .systemFont(ofSize: 15, weight: .medium)
        switch teamMatchups[indexPath.row].result {
            case .win:
                content.secondaryText = "W"
                content.secondaryTextProperties.color = .systemGreen
            case .loss:
                content.secondaryText = "L"
                content.secondaryTextProperties.color = .systemRed
            case .tie:
                content.secondaryText = "T"
                content.secondaryTextProperties.color = .systemBlue
            case .upcoming:
                content.secondaryText = "-"
        }
        cell.contentConfiguration = content
        return cell
    }
    
}
