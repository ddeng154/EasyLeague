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

    var user: User!
    
    var statistics: [(UITextField, UISwitch)] = []
    
    lazy var doneButton = createBarButton(item: .done, selector: #selector(doneButtonPressed))

    lazy var leagueNameField = createTextField(placeholder: "League Name") { field in
        field.autocapitalizationType = .words
    }
    
    lazy var numTeamsField = createTextField(placeholder: "Number of Teams") { field in
        field.keyboardType = .numberPad
    }
    
    lazy var numMatchesField = createTextField(placeholder: "Number of Matches per Team") { field in
        field.keyboardType = .numberPad
    }
    
    lazy var statisticsStack = createVerticalStack()
    
    lazy var addStatisticButton = createButton(title: "Add Statistic", selector: #selector(addStatisticButtonPressed))
    
    lazy var stackView = createVerticalStack()
    
    lazy var scrollView = withAutoLayout(UIScrollView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "New League"
        navigationItem.rightBarButtonItem = doneButton

        stackView.addArrangedSubview(leagueNameField)
        stackView.addArrangedSubview(numTeamsField)
        stackView.addArrangedSubview(numMatchesField)
        stackView.addArrangedSubview(statisticsStack)
        stackView.addArrangedSubview(addStatisticButton)
        
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        
        constrainToSafeArea(scrollView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func presentCreateLeagueError(_ message: String) {
        presentSimpleAlert(title: "Create League Error", message: message)
    }

}

@objc extension CreateLeagueViewController {
    
    func addStatisticButtonPressed() {
        let stack = createVerticalStack(spacing: 10)
        let field = createTextField(placeholder: "Custom Statistic \(statisticsStack.arrangedSubviews.count + 1)")
        stack.addArrangedSubview(field)
        let label = createLabel(text: "Track this statistic for players too")
        let control = withAutoLayout(UISwitch())
        let controlStack = withAutoLayout(UIStackView(arrangedSubviews: [label, control]))
        controlStack.axis = .horizontal
        controlStack.alignment = .fill
        controlStack.distribution = .fill
        stack.addArrangedSubview(controlStack)
        statisticsStack.addArrangedSubview(stack)
        statistics.append((field, control))
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
        let document = Firestore.firestore().leagueCollection.document()
        let stats: [String : Bool] = Dictionary(uniqueKeysWithValues: statistics.compactMap { (field, swtch) in
            guard let text = field.text, !text.isEmpty else { return nil }
            return (text, swtch.isOn)
        })
        let league = League(id: document.documentID, userID: user.id, name: leagueName, numTeams: numTeams, numMatches: numMatches, statistics: stats)
        do {
            try document.setData(from: league)
            popFromNavigation()
        } catch {
            presentCreateLeagueError(error.localizedDescription)
        }
    }
    
}
