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
    
    static let reuseIdentifier = "ChatHomeCell"
    
    var user: User!
    
    var leagues: [League] = []
    
    lazy var leaguesCollection = createCollection(for: self, reuseIdentifier: Self.reuseIdentifier, cellType: UICollectionViewListCell.self)
    
    var leaguesListener: ListenerRegistration?
    
    deinit {
        leaguesListener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Chat"
        
        view.addSubview(leaguesCollection)
        
        constrainToSafeArea(leaguesCollection)
        
        addListener()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func addListener() {
        leaguesListener = Firestore.firestore().leaguesQueryForUser(user.id).addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.presentSimpleAlert(title: "Database Error", message: error.localizedDescription)
            } else if let querySnapshot = querySnapshot {
                self.leagues = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: League.self)
                }.sorted { lhs, rhs in lhs.name < rhs.name }
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

extension ChatHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        leagues.count
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
        content.image = UIImage(named: leagues[indexPath.row].type)
        content.text = leagues[indexPath.row].name
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.contentConfiguration = content
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let controller = ChatViewController()
        controller.sender = Sender(user: user)
        controller.league = leagues[indexPath.row]
        show(controller, sender: self)
    }
    
}
