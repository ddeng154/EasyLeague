//
//  ContentCollectionViewCell.swift
//  EasyLeague
//
//  Created by Daniel Deng on 4/4/22.
//

import Foundation
import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
