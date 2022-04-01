//
//  LeagueHomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/22/22.
//

import UIKit

class LeagueHomeViewController: UIViewController {
    
    var league: League!
    var team: Team!
    
    lazy var spacer: UIView = {
        let spacer = UIView()
        return spacer
    }()
    
    lazy var inviteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Invite Members", for: .normal)
        button.addTarget(self, action: #selector(inviteButtonPressed), for: .touchUpInside)
        return withAutoLayout(button)
    }()
    
    lazy var leagueInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("League Info", for: .normal)
        button.addTarget(self, action: #selector(leagueInfoButtonPressed), for: .touchUpInside)
        return withAutoLayout(button)
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
        
        navigationItem.title = team.name
        
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(inviteButton)
        stackView.addArrangedSubview(leagueInfoButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    @objc func inviteButtonPressed() {
        present(UIActivityViewController(activityItems: [league.id], applicationActivities: nil), animated: true)
    }
    
    @objc func leagueInfoButtonPressed() {
        let leagueInfoController = LeagueInfoViewController()
        leagueInfoController.league = league
        show(leagueInfoController, sender: self)
    }

}
