//
//  SpinnerViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/9/22.
//

import UIKit

class SpinnerViewController: UIViewController {
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.backgroundColor = UIColor(white: 0, alpha: 0.3)
        spinner.layer.cornerRadius = 15
        spinner.layer.masksToBounds = false
        return withAutoLayout(spinner)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 125),
            spinner.widthAnchor.constraint(equalToConstant: 125),
        ])
    }
    
}
