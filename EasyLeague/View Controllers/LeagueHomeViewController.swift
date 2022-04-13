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
    
    let contentCellIdentifier = "ContentCellIdentifier"
    
    lazy var teamsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CustomCollectionViewLayout())
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: contentCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return withAutoLayout(collectionView)
    }()
    
    lazy var inviteButton = createBarButton(item: .action, action: #selector(inviteButtonPressed))
    
    lazy var spacer = createSpacer()
    
    lazy var leagueStartedLabel = createLabel()
    
    lazy var startLeagueButton = createButton(title: "Start League", action: #selector(startLeagueButtonPressed))
    
    lazy var enterScoresButton = createButton(title: "Enter Scores", action: #selector(enterScoresButtonPressed))
    
    lazy var leagueInfoButton = createButton(title: "League Info", action: #selector(leagueInfoButtonPressed))
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = team.name
        navigationItem.rightBarButtonItem = inviteButton
        
        stackView.addArrangedSubview(teamsCollectionView)
        stackView.addArrangedSubview(leagueStartedLabel)
        stackView.addArrangedSubview(spacer)
        if league.isStarted {
            leagueStartedLabel.text = "League is underway!"
            if user.id == league.ownerUserID && league.numMatchesPlayed < league.numMatches {
                stackView.addArrangedSubview(enterScoresButton)
            }
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
        league.playerStats = league.playerStats.mapValues { _ in Dictionary(uniqueKeysWithValues: league.memberUserIDs.map { userID in (userID, Statistic()) }) }
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
    
    func enterScoresButtonPressed() {
        let enterScoresController = EnterScoresViewController()
        enterScoresController.league = league
        show(enterScoresController, sender: self)
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


extension LeagueHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return league.teams.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return league.teamStats.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellIdentifier, for: indexPath) as! ContentCollectionViewCell
        if indexPath.section % 2 != 0 {
                    cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    cell.backgroundColor = UIColor.white
                }

                if indexPath.section == 0 {
                    if indexPath.row == 0 {
                        cell.label.text = "Teams"
                        cell.label.font = UIFont.boldSystemFont(ofSize: cell.label.font.pointSize)
                    } else {
                        var sortedKeys = Array(league.teamStats.keys)
                        sortedKeys.sort(by: {$0 < $1})
                        cell.label.text = sortedKeys[indexPath.row - 1]
                        cell.label.font = UIFont.boldSystemFont(ofSize: cell.label.font.pointSize)
                    }
                } else {
                    if indexPath.row == 0 {
                        cell.label.text = league.teams[indexPath.section - 1].name
                        cell.label.font = UIFont.boldSystemFont(ofSize: cell.label.font.pointSize)
                    } else {
                        cell.label.text = "Content"
                    }
                }

                return cell
    }
}

extension LeagueHomeViewController: UICollectionViewDelegate {
    
}
