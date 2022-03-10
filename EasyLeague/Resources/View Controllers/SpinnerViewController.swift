//
//  SpinnerViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/9/22.
//

import UIKit

class SpinnerViewController: UIViewController {
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        return withAutoLayout(spinner)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
}
