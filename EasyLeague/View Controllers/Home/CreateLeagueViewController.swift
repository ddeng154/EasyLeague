//
//  CreateLeagueViewController.swift
//  EasyLeague
//
//  Created by Daniel Deng on 3/15/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class CreateLeagueViewController: UIViewController {
    
    static let forPlayerOptions = ["Players and Teams", "Teams Only"]

    var user: User!
    
    var leagueType: (name: String, stats: [(name: String, forPlayer: Bool)])!
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))

    lazy var leagueNameField = createTextField(placeholder: "League Name") { field in
        field.autocapitalizationType = .words
    }
    
    lazy var numTeamsField = createTextField(placeholder: "Number of Teams") { field in
        field.keyboardType = .numberPad
    }
    
    lazy var numMatchesField = createTextField(placeholder: "Number of Matches per Team") { field in
        field.keyboardType = .numberPad
    }
    
    lazy var statistics: [(field: UITextField, control: UISegmentedControl)] = leagueType.stats.map { (name, forPlayer) in
        (createTextField(text: name, height: 35), createSegmentedControl(items: Self.forPlayerOptions, selected: forPlayer ? 0 : 1))
    }
    
    lazy var statisticsTable = createTable(for: self) { table in
        table.allowsSelection = false
    }
    
    lazy var addStatisticButton = createButton(title: "Add Statistic", action: #selector(addStatisticButtonPressed))
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "New League"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton

        stackView.addArrangedSubview(leagueNameField)
        stackView.addArrangedSubview(numTeamsField)
        stackView.addArrangedSubview(numMatchesField)
        stackView.addArrangedSubview(statisticsTable)
        stackView.addArrangedSubview(addStatisticButton)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentCreateLeagueError(_ message: String) {
        presentSimpleAlert(title: "Create League Error", message: message)
    }

}

@objc extension CreateLeagueViewController {
    
    func addStatisticButtonPressed() {
        statistics.append((createTextField(placeholder: "Custom Stat", height: 35), createSegmentedControl(items: Self.forPlayerOptions)))
        statisticsTable.reloadData()
        statisticsTable.scrollToRow(at: IndexPath(row: statistics.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    func doneButtonPressed() {
        guard leagueNameField.hasText, let leagueName = leagueNameField.text else {
            return presentCreateLeagueError("League Name field is empty")
        }
        guard numTeamsField.hasText, let numTeams = Int(numTeamsField.text), numTeams >= 2 else {
            return presentCreateLeagueError("Number of Teams must be a valid integer greater than or equal to 2")
        }
        guard numMatchesField.hasText, let numMatches = Int(numMatchesField.text), numMatches >= 1 else {
            return presentCreateLeagueError("Number of Matches must be a valid integer greater than or equal to 1")
        }
        guard statistics.count == Set(statistics.compactMap { (field, _) in field.hasText ? field.text : nil }).count else {
            return presentCreateLeagueError("Each statistic must have a unique, nonempty name")
        }
        let document = Firestore.firestore().leagueCollection.document()
        let stats: [String : Bool] = Dictionary(uniqueKeysWithValues: statistics.compactMap { (field, control) in
            guard let text = field.text, !text.isEmpty else { return nil }
            return (text, control.selectedSegmentIndex == 0)
        })
        let league = League(id: document.documentID, userID: user.id, name: leagueName, numTeams: numTeams, numMatches: numMatches, stats: stats, type: leagueType.name)
        do {
            try document.setData(from: league) { error in
                if let error = error {
                    self.presentCreateLeagueError(error.localizedDescription)
                } else {
                    self.popFromNavigation()
                    self.popFromNavigation()
                }
            }
        } catch {
            presentCreateLeagueError(error.localizedDescription)
        }
    }
    
}

extension CreateLeagueViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let stat = statistics[indexPath.row]
        let stack = createVerticalStack(for: [stat.field, stat.control], spacing: 5)
        cell.contentView.addSubview(stack)
        constrainToSafeArea(stack, superview: cell.contentView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            statistics.remove(at: indexPath.row)
            statisticsTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
