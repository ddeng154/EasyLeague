//
//  HomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {

    var user: User!
    
    var leagues: [(league: League, team: Team)] = []
    
    lazy var leaguesTable = createTable(for: self)
    
    lazy var createLeagueButton = createButton(title: "Create League", selector: #selector(createLeagueButtonPressed))
    
    lazy var joinLeagueButton = createButton(title: "Join League", selector: #selector(joinLeagueButtonPressed))
    
    lazy var stackView = createVerticalStack()
    
    var snapshotListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Home"
        
        stackView.addArrangedSubview(leaguesTable)
        stackView.addArrangedSubview(createLeagueButton)
        stackView.addArrangedSubview(joinLeagueButton)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        snapshotListener?.remove()
    }
    
    func presentDatabaseError(_ message: String) {
        presentSimpleAlert(title: "Database Error", message: message)
    }
    
    func addListener() {
        snapshotListener = Firestore.firestore().leaguesQueryForUser(user.id).addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.presentDatabaseError(error.localizedDescription)
            } else if let querySnapshot = querySnapshot {
                self.leagues = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                    guard let league = try? queryDocumentSnapshot.data(as: League.self) else { return nil }
                    guard let team = league.teamWith(userID: self.user.id) else { return nil }
                    return (league, team)
                }.sorted { lhs, rhs in lhs.team.name < rhs.team.name }
                self.leaguesTable.reloadData()
            }
        }
    }

}

@objc extension HomeViewController {
    
    func createLeagueButtonPressed() {
        let createController = CreateLeagueViewController()
        createController.user = user
        show(createController, sender: self)
    }
    
    func joinLeagueButtonPressed() {
        let joinController = JoinLeagueViewController()
        joinController.user = user
        show(joinController, sender: self)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.valueCell()
        content.text = leagues[indexPath.row].team.name
        content.secondaryText = leagues[indexPath.row].league.name
        content.prefersSideBySideTextAndSecondaryText = true
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = LeagueHomeViewController()
        controller.user = user
        controller.league = leagues[indexPath.row].league
        controller.team = leagues[indexPath.row].team
        show(controller, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Firestore.firestore().leagueCollection.document(leagues[indexPath.row].league.id).delete { error in
                if let error = error {
                    self.presentDatabaseError(error.localizedDescription)
                }
            }
        }
    }
    
}
