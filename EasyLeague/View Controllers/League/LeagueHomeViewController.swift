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
    
    static let reuseIdentifier = "LeagueHomeButtonsCell"
    
    static let buttons: [(name: String, imageName: String, color: UIColor, controller: (League) -> UIViewController)] = [
        ("Standings", "list.number", .systemRed, { league in
            let controller = StandingsViewController()
            controller.league = league
            return controller
        }),
        ("Team Statistics", "person.2.fill", .systemOrange, { league in
            let controller = LeagueInfoViewController()
            controller.league = league
            return controller
        }),
        ("Player Statistics", "figure.walk", .systemYellow, { league in
            let controller = LeagueInfoViewController()
            controller.league = league
            return controller
        }),
        ("League Info", "info", .systemGreen, { league in
            let controller = LeagueInfoViewController()
            controller.league = league
            return controller
        }),
    ]
    
    var user: User!
    
    var league: League!
    
    var team: Team!
    
    lazy var editButton = createBarButton(item: .edit, action: #selector(editButtonPressed))
    
    lazy var buttonsCollection = createCollection(for: self, reuseIdentifier: Self.reuseIdentifier, cellType: UICollectionViewListCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = league.name
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButton
        
        view.addSubview(buttonsCollection)
        
        constrainToSafeArea(buttonsCollection)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func configureLayout() {
        if let layout = buttonsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: buttonsCollection.bounds.width - 20, height: 75)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        }
    }

}

@objc extension LeagueHomeViewController {
    
    func editButtonPressed() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Share Invite Identifier", style: .default) { _ in
            let activity = UIActivityViewController(activityItems: [self.league.id], applicationActivities: nil)
            self.present(activity, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Edit League", style: .default) { _ in
            
        })
        alert.addAction(UIAlertAction(title: "Enter Scores", style: .default) { _ in
            guard self.user.id == self.league.ownerUserID else {
                return self.presentSimpleAlert(title: "Enter Scores Error", message: "Only the league owner can enter scores")
            }
            guard self.league.results.count < self.league.schedule.count else {
                return self.presentSimpleAlert(title: "Enter Scores Error", message: "League is over!")
            }
            let controller = EnterScoresViewController()
            controller.league = self.league
            self.show(controller, sender: self)
        })
        present(alert, animated: true)
    }
    
}

extension LeagueHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Self.buttons.count
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
        let data = Self.buttons[indexPath.row]
        content.text = data.name
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        content.image = UIImage(systemName: data.imageName)
        content.imageProperties.tintColor = data.color
        cell.contentConfiguration = content
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        show(Self.buttons[indexPath.row].controller(league), sender: self)
    }
    
}
