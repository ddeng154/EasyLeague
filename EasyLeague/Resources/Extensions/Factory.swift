//
//  Factory.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/8/22.
//

import UIKit

extension UIViewController {
    
    func createSpacer(customize: ((UIView) -> Void)? = nil) -> UIView {
        let spacer = UIView()
        customize?(spacer)
        return withAutoLayout(spacer)
    }
    
    func createVerticalStack(spacing: CGFloat = 20, customize: ((UIStackView) -> Void)? = nil) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = spacing
        customize?(stack)
        return withAutoLayout(stack)
    }
    
    func createHorizontalStack(for subviews: [UIView], customize: ((UIStackView) -> Void)? = nil) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        customize?(stack)
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
    
    func createButton(title: String, action: Selector, customize: ((UIButton) -> Void)? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.tintColor = .white
        button.setBackgroundColor(.appAccent, for: .normal)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17)
        customize?(button)
        return withAutoLayout(button)
    }
    
    func createTable(for vc: UITableViewDelegate & UITableViewDataSource, customize: ((UITableView) -> Void)? = nil) -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .appBackground
        tableView.delegate = vc
        tableView.dataSource = vc
        customize?(tableView)
        return withAutoLayout(tableView)
    }
    
    func createSwitch(action: Selector, customize: ((UISwitch) -> Void)? = nil) -> UISwitch {
        let swtch = UISwitch()
        swtch.addTarget(self, action: action, for: .valueChanged)
        customize?(swtch)
        return withAutoLayout(swtch)
    }
    
    func createBarButton(item: UIBarButtonItem.SystemItem, action: Selector, customize: ((UIBarButtonItem) -> Void)? = nil) -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: item, target: self, action: action)
        customize?(button)
        return button
    }
    
}
