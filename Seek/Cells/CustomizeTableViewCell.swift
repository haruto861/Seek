//
//  CustomizeTableViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/19.
//

import UIKit

class CustomizeTableViewCell: UITableViewCell {
    
    @IBOutlet private var customizeImageView: UIImageView!
    @IBOutlet private var customizeNameLabel: UILabel!
    @IBOutlet private var customCalorieLabel: UILabel!
    @IBOutlet private var customPriceLabel: UILabel!
    var customizeArrays = [Customize]()
    var indexPath: IndexPath?

    override func layoutSubviews() {
       if customizeArrays.count > 0 {
        guard let indexPath = indexPath else { return }
        let customizes = customizeArrays[indexPath.row].customizeName
        customizeNameLabel.text = "\(customizes ?? "")"
        let customizeCalories = customizeArrays[indexPath.row].customizeCalorie
        customCalorieLabel.text = "\(customizeCalories ?? 0)"
        let customizePrices = customizeArrays[indexPath.row].customizePrice
        customPriceLabel.text = "\(customizePrices ?? 0)"
        customizeImageView.kf.setImage(with: URL(string: customizeArrays[indexPath.row].customizeImageUrl))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.contentView.backgroundColor = #colorLiteral(red: 0.1345807016, green: 0.2179155946, blue: 0.2592018545, alpha: 1)
        } else {
            self.contentView.backgroundColor = .none
        }
    }
}
