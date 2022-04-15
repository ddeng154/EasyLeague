//
//  MatchupsViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

import UIKit

class MatchupsViewController: UIViewController {
    
    var league: League!
    
    lazy var placeholderLabel = createLabel(text: "Matchups coming soon") { label in
        label.textAlignment = .center
    }
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Matchups"
        navigationItem.largeTitleDisplayMode = .never
        
        stackView.addArrangedSubview(placeholderLabel)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }

}
