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
    @IBOutlet private weak var mainBackground: UIView!
    @IBOutlet private weak var shadowLayer: UIView!
    var customizeArrays = [Customize]()
    var indexPath: IndexPath?

    override func layoutSubviews() {
       if customizeArrays.count > 0 {
        guard let indexPath = indexPath else { return }
        let customizes = customizeArrays[indexPath.row].customizeName
        customizeNameLabel.text = "\(customizes ?? "")"
        customizeImageView.kf.setImage(with: URL(string: customizeArrays[indexPath.row].customizeImageUrl))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
