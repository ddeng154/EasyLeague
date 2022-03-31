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

    var user: User!
    
    var leagues: [League] = []
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.text = user.displayName
        return withAutoLayout(label)
    }()
    
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo.circle"))
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        user.storageReferenceForPhoto.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let data = data {
                imageView.image = UIImage(data: data)
            }
        }
        return withAutoLayout(imageView)
    }()
    
    lazy var userStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userLabel, userPhoto])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        return withAutoLayout(stack)
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
    
    lazy var joinLeagueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Join League", for: .normal)
        button.addTarget(self, action: #selector(joinLeagueButtonPressed), for: .touchUpInside)
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
        
        navigationItem.title = "Home"
        
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(leaguesTable)
        stackView.addArrangedSubview(createLeagueButton)
        stackView.addArrangedSubview(joinLeagueButton)
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
        addListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        snapshotListener?.remove()
    }
    
    func presentDatabaseError(_ message: String) {
        presentSimpleAlert(title: "Database Error", message: message)
    }
    
    func addListener() {
        snapshotListener = Firestore.firestore().leaguesQueryForUser(user.uid).addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.presentDatabaseError(error.localizedDescription)
            } else if let querySnapshot = querySnapshot {
                self.leagues = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: League.self)
                }.sorted { lhs, rhs in lhs.name < rhs.name }
                self.leaguesTable.reloadData()
            }
        }
    }
    
    @objc func createLeagueButtonPressed() {
        let createController = CreateLeagueViewController()
        createController.user = user
        show(createController, sender: self)
    }
    
    @objc func joinLeagueButtonPressed() {
        let joinController = JoinLeagueViewController()
        joinController.user = user
        show(joinController, sender: self)
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
            Firestore.firestore().leagueCollection.document(leagues[indexPath.row].id).delete { error in
                if let error = error {
                    self.presentDatabaseError(error.localizedDescription)
                }
            }
        }
    }
    
}
