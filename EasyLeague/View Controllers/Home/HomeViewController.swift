//
//  HomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {
    
    static let reuseIdentifier = "HomeLeaguesCell"

    var user: User!
    
    var leagues: [(league: League, team: Team)] = []
    
    lazy var createLeagueButton = createCustomBarButton(title: "Create", action: #selector(createLeagueButtonPressed))
    
    lazy var joinLeagueButton = createCustomBarButton(title: "Join", action: #selector(joinLeagueButtonPressed))
    
    lazy var emptyMessageLabel = createLabel(text: "Create or join a league to get started!") { label in
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
    }
    
    lazy var leaguesCollection = createCollection(for: self, reuseIdentifier: Self.reuseIdentifier, cellType: UICollectionViewListCell.self)
    
    var leaguesListener: ListenerRegistration?
    
    deinit {
        leaguesListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "EasyLeague"
        navigationItem.rightBarButtonItems = [createLeagueButton, joinLeagueButton]
        
        view.addSubview(leaguesCollection)
        
        constrainToSafeArea(leaguesCollection)
        
        addListener()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func presentDatabaseError(_ message: String) {
        presentSimpleAlert(title: "Database Error", message: message)
    }
    
    func addListener() {
        leaguesListener = Firestore.firestore().leaguesQueryForUser(user.id).addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.presentDatabaseError(error.localizedDescription)
            } else if let querySnapshot = querySnapshot {
                self.leagues = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                    guard let league = try? queryDocumentSnapshot.data(as: League.self) else { return nil }
                    guard let team = league.teamWith(userID: self.user.id) else { return nil }
                    return (league, team)
                }.sorted { lhs, rhs in lhs.league.name < rhs.league.name }
                self.leaguesCollection.reloadData()
            }
        }
    }
    
    func configureLayout() {
        if let layout = leaguesCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: leaguesCollection.bounds.width - 15, height: 90)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        }
    }

}

@objc extension HomeViewController {
    
    func createLeagueButtonPressed() {
        let chooseTypeController = ChooseLeagueTypeViewController()
        chooseTypeController.user = user
        show(chooseTypeController, sender: self)
    }
    
    func joinLeagueButtonPressed() {
        let joinController = JoinLeagueViewController()
        joinController.user = user
        show(joinController, sender: self)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if leagues.isEmpty {
            collectionView.setBackground(emptyMessageLabel)
        } else {
            collectionView.clearBackground()
        }
        return leagues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath)
        guard let cell = cell as? UICollectionViewListCell else { return cell }
        cell.accessories = [.disclosureIndicator()]
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 1, height: 2)
        cell.layer.shadowRadius = 3
        
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = .systemGray6
        background.cornerRadius = 15
        cell.backgroundConfiguration = background
        
        var content = cell.defaultContentConfiguration()
        let data = leagues[indexPath.row]
        content.image = UIImage(named: data.league.type)
        content.text = data.league.name
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        content.secondaryText = data.team.name
        content.secondaryTextProperties.font = .systemFont(ofSize: 14, weight: .light)
        cell.contentConfiguration = content
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let controller = LeagueHomeViewController()
        controller.user = user
        controller.league = leagues[indexPath.row].league
        controller.team = leagues[indexPath.row].team
        show(controller, sender: self)
    }
    
}
