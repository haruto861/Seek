//
//  PostTableViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/29.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var passedCustomizeLabel: UILabel!
    var customizeArrays = [Customize]()
    var indexPath: IndexPath?

    override func layoutSubviews() {
        if customizeArrays.count > 0 {
            guard let indexPath = indexPath else { return }
            guard let customizeNames = customizeArrays[indexPath.row].customizeName else { return }
            passedCustomizeLabel.text = customizeNames
        }
    }
}
