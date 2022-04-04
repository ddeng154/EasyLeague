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
    
    lazy var spacer = createSpacer()
    
    lazy var inviteButton = createButton(title: "Invite Members", selector: #selector(inviteButtonPressed))
    
    lazy var leagueInfoButton = createButton(title: "League Info", selector: #selector(leagueInfoButtonPressed))
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        navigationItem.title = team.name
        
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(inviteButton)
        stackView.addArrangedSubview(leagueInfoButton)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }

}

@objc extension LeagueHomeViewController {
    
    func inviteButtonPressed() {
        present(UIActivityViewController(activityItems: [league.id], applicationActivities: nil), animated: true)
    }
    
    func leagueInfoButtonPressed() {
        let leagueInfoController = LeagueInfoViewController()
        leagueInfoController.league = league
        show(leagueInfoController, sender: self)
    }
    
}
