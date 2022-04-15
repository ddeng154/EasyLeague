//
//  EnterResultsViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

import UIKit

class EnterMatchupResultsViewController: UIViewController {
    
    var league: League!
    
    var matchup: Matchup!
    
    var completion: ((Outcome) -> Void)!
    
    lazy var statNames = league.teamStats.keys.sorted()
    
    lazy var teamAStats = statNames.map { _ in
        createTextField(placeholder: "0", height: 30) { field in
            field.keyboardType = .numberPad
            field.textAlignment = .right
        }
    }
    
    lazy var teamBStats = statNames.map { _ in
        createTextField(placeholder: "0", height: 30) { field in
            field.keyboardType = .numberPad
            field.textAlignment = .right
        }
    }
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))
    
    lazy var winnerLabel = createLabel(text: "Select Winner") { label in
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    lazy var winnerControl = createSegmentedControl(items: [league.teams[matchup.teamA].name, league.teams[matchup.teamB].name])
    
    lazy var winnerStack = createVerticalStack(for: [winnerLabel, winnerControl], spacing: 10)
    
    lazy var tableView = createTable(for: self) { table in
        table.allowsSelection = false
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

}

@objc extension EnterMatchupResultsViewController {
    
    func doneButtonPressed() {
        let (winner, loser) = winnerControl.selectedSegmentIndex == 0 ? (matchup.teamA, matchup.teamB) : (matchup.teamB, matchup.teamA)
        let statsA = teamAStats.compactMap { field in Int(field.text) }
        let statsB = teamBStats.compactMap { field in Int(field.text) }
        guard statsA.count == statNames.count && statsB.count == statNames.count else {
            return self.presentEnterResultsError("Please enter a valid integer for each statistic")
        }
        completion(Outcome(winner: winner, loser: loser))
        popFromNavigation()
    }
    
    func tableTapRecognized() {
        view.endEditing(true)
    }
    
}

extension EnterMatchupResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(section == 0 ? league.teams[matchup.teamA].name : league.teams[matchup.teamB].name) Statistics"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        league.teamStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let label = createLabel(text: statNames[indexPath.row])
        label.font = .systemFont(ofSize: 15, weight: .medium)
        let field = indexPath.section == 0 ? teamAStats[indexPath.row] : teamBStats[indexPath.row]
        let stack = createHorizontalStack(for: [label, field], distribution: .fillEqually, alignment: .center)
        
        cell.contentView.addSubview(stack)
        constrainToSafeArea(stack, superview: cell.contentView)
        
        return cell
    }
    
}
