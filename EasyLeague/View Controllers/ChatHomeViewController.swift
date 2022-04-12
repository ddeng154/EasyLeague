//
//  ChatHomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/12/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatHomeViewController: UIViewController {
    
    var user: User!
    
    var leagues: [League] = []
    
    lazy var leaguesTable = createTable(for: self)
    
    lazy var stackView = createVerticalStack()
    
    var leaguesListener: ListenerRegistration?
    
    deinit {
        leaguesListener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Chat"
        
        stackView.addArrangedSubview(leaguesTable)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
        
        addListener()
    }
    
    func addListener() {
        leaguesListener = Firestore.firestore().leaguesQueryForUser(user.id).addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.presentSimpleAlert(title: "Database Error", message: error.localizedDescription)
            } else if let querySnapshot = querySnapshot {
                self.leagues = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: League.self)
                }.sorted { lhs, rhs in lhs.name < rhs.name }
                self.leaguesTable.reloadData()
            }
        }
    }

}

extension ChatHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.cell()
        content.text = leagues[indexPath.row].name
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .appBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ChatViewController()
        controller.sender = Sender(user: user)
        controller.league = leagues[indexPath.row]
        show(controller, sender: self)
    }
    
}
