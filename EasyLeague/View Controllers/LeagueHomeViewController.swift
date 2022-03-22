//
//  LeagueHomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/22/22.
//

import UIKit

class LeagueHomeViewController: UIViewController {
    
    var league: League!
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = league.name
        return label
    }()
    
    lazy var numTeamsLabel: UILabel = {
        let label = UILabel()
        label.text = "Number of Teams: \(league.numTeams)"
        return label
    }()
    
    lazy var numMatchesLabel: UILabel = {
        let label = UILabel()
        label.text = "Number of Matches: \(league.numMatches)"
        return label
    }()
    
    lazy var spacer: UIView = {
        let spacer = UIView()
        return spacer
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 20
        return withAutoLayout(stack)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(numTeamsLabel)
        stackView.addArrangedSubview(numMatchesLabel)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }

}
