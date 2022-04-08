//
//  LeagueHomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/22/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class LeagueHomeViewController: UIViewController {
    
    var user: User!
    
    var league: League!
    
    var team: Team!
    
    lazy var inviteButton = createBarButton(item: .action, selector: #selector(inviteButtonPressed))
    
    lazy var spacer = createSpacer()
    
    lazy var leagueStartedLabel = createLabel()
    
    lazy var startLeagueButton = createButton(title: "Start League", selector: #selector(startLeagueButtonPressed))
    
    lazy var leagueInfoButton = createButton(title: "League Info", selector: #selector(leagueInfoButtonPressed))
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = team.name
        navigationItem.rightBarButtonItem = inviteButton
        
        stackView.addArrangedSubview(leagueStartedLabel)
        stackView.addArrangedSubview(spacer)
        if league.isStarted {
            leagueStartedLabel.text = "League is underway!"
            
        } else {
            leagueStartedLabel.text = "League has not started yet"
            if user.id == league.ownerUserID {
                stackView.addArrangedSubview(startLeagueButton)
            }
        }
        stackView.addArrangedSubview(leagueInfoButton)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }

}

@objc extension LeagueHomeViewController {
    
    func startLeagueButtonPressed() {
        league.isStarted = true
        do {
            try Firestore.firestore().leagueCollection.document(league.id).setData(from: league)
            leagueStartedLabel.text = "League is underway!"
            stackView.removeArrangedSubview(startLeagueButton)
            startLeagueButton.removeFromSuperview()
        } catch {
            league.isStarted = false
            presentSimpleAlert(title: "Start League Error", message: error.localizedDescription)
        }
    }
    
    func inviteButtonPressed() {
        present(UIActivityViewController(activityItems: [league.id], applicationActivities: nil), animated: true)
    }
    
    func leagueInfoButtonPressed() {
        let leagueInfoController = LeagueInfoViewController()
        leagueInfoController.league = league
        show(leagueInfoController, sender: self)
    }
    
}
