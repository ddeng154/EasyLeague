//
//  EnterScoresViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/8/22.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class EnterScoresViewController: UIViewController {
    
    var league: League!
    
    lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Enter Scores"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func presentEnterScoresError(_ message: String) {
        presentSimpleAlert(title: "Enter Scores Error", message: message)
    }

}

@objc extension EnterScoresViewController {
    
    func doneButtonPressed() {
        popFromNavigation()
    }
    
}
