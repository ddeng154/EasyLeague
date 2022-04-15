//
//  EditLeagueViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

import UIKit

class EditLeagueViewController: UIViewController {
    
    var league: League!
    
    lazy var doneButton = createBarButton(item: .done, action: #selector(doneButtonPressed))
    
    lazy var placeholderLabel = createLabel(text: "Edit League coming soon") { label in
        label.textAlignment = .center
    }
    
    lazy var stackView = createVerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Edit League"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton
        
        stackView.addArrangedSubview(placeholderLabel)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
}

@objc extension EditLeagueViewController {
    
    func doneButtonPressed() {
        popFromNavigation()
    }
    
}
