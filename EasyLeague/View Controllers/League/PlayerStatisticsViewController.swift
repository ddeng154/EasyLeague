//
//  PlayerStatisticsViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

import UIKit

class PlayerStatisticsViewController: UIViewController {
    
    var league: League!
    
    lazy var allStats: [(name: String, stats: [(name: String, val: Int)])] = league.playerStats.map { name, stats in
        (name, stats.compactMap { (id, val) in
            guard let user = Shared.userMap[id] else { return nil }
            return (user.name, val)
        })
    }.sorted { lhs, rhs in lhs.name < rhs.name }
    
    lazy var statPicker = createPicker(for: self, selectedRow: self.allStats.count / 2)
    
    lazy var nameLabel = createLabel(text: "    Name") { label in
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var recordLabel = createLabel(text: "Value    ") { label in
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var headerStack = createHorizontalStack(for: [nameLabel, recordLabel])
    
    lazy var statsTable = createTable(for: self)
    
    lazy var stackView = createVerticalStack()
    
    var stats: [(name: String, val: Int)] {
        allStats[statPicker.selectedRow(inComponent: 0)].stats.sorted { lhs, rhs in lhs.val > rhs.val }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        navigationItem.title = "Player Statistics"
        navigationItem.largeTitleDisplayMode = .never
        
        stackView.addArrangedSubview(statPicker)
        stackView.addArrangedSubview(headerStack)
        stackView.addArrangedSubview(statsTable)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
}

extension PlayerStatisticsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        allStats.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        allStats[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statsTable.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40
    }
    
}

extension PlayerStatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.valueCell()
        content.text = "\(indexPath.row + 1).\t\(stats[indexPath.row].name)"
        content.secondaryText = String(stats[indexPath.row].val)
        content.textProperties.font = .systemFont(ofSize: 15, weight: .medium)
        content.secondaryTextProperties.font = .systemFont(ofSize: 15, weight: .medium)
        cell.contentConfiguration = content
        return cell
    }
    
}
