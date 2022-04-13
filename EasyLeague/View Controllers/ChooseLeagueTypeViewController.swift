//
//  ChooseLeagueTypeViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/13/22.
//

import UIKit

class ChooseLeagueTypeViewController: UIViewController {
    
    static let reuseIdentifier = "LeagueTypeCollectionViewCellReuseIdentifier"
    
    var user: User!
    
    let choices = [
        ("Basketball", [("Points", true), ("Rebounds", true), ("Assists", true), ("Steals", false), ("Blocks", false)]),
        ("Hockey", [("Goals", true), ("Assists", true), ("Shots on Goal", false)]),
        ("Football", [("Passing Touchdowns", true), ("Receiving Touchdowns", true), ("Rushing Touchdowns", true), ("Turnovers", false)]),
        ("Volleyball", [("Kills", true), ("Assists", true), ("Total Blocks", false)]),
        ("Soccer", [("Goals", true), ("Assists", true), ("Shots", false), ("Tackles", false)]),
        ("Custom", []),
    ]
    
    lazy var choicesCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Self.reuseIdentifier)
        return withAutoLayout(collection)
    }()

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
            let size = (choicesCollection.bounds.width - 25) / 2
            layout.itemSize = CGSize(width: size, height: size)
            layout.minimumInteritemSpacing = 15
            layout.minimumLineSpacing = 15
            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
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
        cell.layer.borderColor = UIColor.systemGray6.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.systemGray5.cgColor
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowOffset = CGSize(width: 4, height: 4)
        cell.layer.shadowRadius = 4
        
        let image = withAutoLayout(UIImageView(image: UIImage(named: choices[indexPath.row].0)))
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
