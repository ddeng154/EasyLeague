//
//  Factory.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/8/22.
//

import UIKit

extension UIViewController {
    
    func createSpacer() -> UIView {
        let spacer = UIView()
        return withAutoLayout(spacer)
    }
    
    func createVerticalStack(spacing: CGFloat = 20) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = spacing
        return withAutoLayout(stack)
    }
    
    func createLabel(text: String? = nil, customize: ((UILabel) -> Void)? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        customize?(label)
        return withAutoLayout(label)
    }
    
    func createTextField(placeholder: String? = nil, customize: ((UITextField) -> Void)? = nil) -> UITextField {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = placeholder
        field.heightAnchor.constraint(equalToConstant: 40).isActive = true
        field.delegate = self
        customize?(field)
        return withAutoLayout(field)
    }
    
    func createButton(title: String, selector: Selector, customize: ((UIButton) -> Void)? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.tintColor = .white
        button.setBackgroundColor(.appAccent, for: .normal)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17)
        customize?(button)
        return withAutoLayout(button)
    }
    
    func createTable(for vc: UITableViewDelegate & UITableViewDataSource) -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .appBackground
        tableView.delegate = vc
        tableView.dataSource = vc
        return withAutoLayout(tableView)
    }
    
    func createBarButton(item: UIBarButtonItem.SystemItem, selector: Selector, customize: ((UIBarButtonItem) -> Void)? = nil) -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: item, target: self, action: selector)
        customize?(button)
        return button
    }
    
}
