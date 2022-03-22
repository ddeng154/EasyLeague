//
//  HomeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class HomeViewController: UIViewController {

    var leagues: [League] = []
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return withAutoLayout(label)
    }()
    
    lazy var leaguesTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return withAutoLayout(tableView)
    }()
    
    lazy var createLeagueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create League", for: .normal)
        button.addTarget(self, action: #selector(createLeagueButtonPressed), for: .touchUpInside)
        return withAutoLayout(button)
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
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
    
    var snapshotListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(userLabel)
        stackView.addArrangedSubview(leaguesTable)
        stackView.addArrangedSubview(createLeagueButton)
        stackView.addArrangedSubview(logOutButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        snapshotListener?.remove()
    }
    
    func presentDatabaseError(_ message: String) {
        presentSimpleAlert(title: "Database Error", message: message)
    }
    
    func snapshotListener(querySnapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            presentDatabaseError(error.localizedDescription)
        } else if let querySnapshot = querySnapshot {
            leagues = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: League.self)
            }.sorted { lhs, rhs in lhs.name < rhs.name }
            leaguesTable.reloadData()
        }
    }
    
    func loadUserData() {
        if let user = Auth.auth().currentUser {
            userLabel.text = user.displayName
            snapshotListener = Firestore.firestore().leagueCollection.addSnapshotListener(snapshotListener)
        }
    }
    
    @objc func createLeagueButtonPressed() {
        show(CreateLeagueViewController(), sender: self)
    }

    @objc func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch {
            presentSimpleAlert(title: "Log Out Error", message: error.localizedDescription)
        }
    }

}

extension HomeViewController: UITableViewDelegate { }

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = leagues[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = LeagueHomeViewController()
        controller.league = leagues[indexPath.row]
        show(controller, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Firestore.firestore().leagueCollection.document(leagues[indexPath.row].id).delete()
        }
    }
    
}
