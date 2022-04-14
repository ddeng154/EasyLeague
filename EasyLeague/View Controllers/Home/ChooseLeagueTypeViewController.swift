//
//  ChooseLeagueTypeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/13/22.
//

import UIKit

class ChooseLeagueTypeViewController: UIViewController {
    
    static let reuseIdentifier = "ChooseLeagueTypeCell"
    
    var user: User!
    
    let choices = [
        ("Basketball", [("Points", true), ("Rebounds", true), ("Assists", true), ("Steals", false), ("Blocks", false)]),
        ("Hockey", [("Goals", true), ("Assists", true), ("Shots on Goal", false)]),
        ("Football", [("Passing Touchdowns", true), ("Receiving Touchdowns", true), ("Rushing Touchdowns", true), ("Turnovers", false)]),
        ("Volleyball", [("Kills", true), ("Assists", true), ("Total Blocks", false)]),
        ("Soccer", [("Goals", true), ("Assists", true), ("Shots", false), ("Tackles", false)]),
        ("Custom", []),
    ]
    
    lazy var choicesCollection = createCollection(for: self, reuseIdentifier: Self.reuseIdentifier)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Choose League Type"
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(choicesCollection)
        
        constrainToSafeArea(choicesCollection)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func configureLayout() {
        if let layout = choicesCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            let size = (choicesCollection.bounds.width - 30) / 2
            layout.itemSize = CGSize(width: size, height: size)
            layout.minimumInteritemSpacing = 15
            layout.minimumLineSpacing = 15
            layout.sectionInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        }
    }

}

extension ChooseLeagueTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath)
        cell.backgroundColor = .systemGray6
        
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 1, height: 2)
        cell.layer.shadowRadius = 3
        
        let image = createImageView(name: choices[indexPath.row].0)
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let label = createLabel(text: choices[indexPath.row].0)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        
        let stack = createVerticalStack(for: [image, label], spacing: 0, distribution: .equalCentering, alignment: .center)
        cell.contentView.addSubview(stack)
        
        constrainToSafeArea(stack, superview: cell.contentView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let createController = CreateLeagueViewController()
        createController.user = user
        createController.leagueType = choices[indexPath.row]
        show(createController, sender: self)
    }
    
}
