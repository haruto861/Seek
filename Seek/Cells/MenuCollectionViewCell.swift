//
//  MenuCollectionViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/15.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet var menuNameLabel: UILabel!
    @IBOutlet var menuImageView: UIImageView!
    var indexPath: IndexPath?
    var menuArrays = [Menu]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        if menuArrays.count > 0 {
            guard let indexPath = indexPath else { return }
            guard let menuName = menuArrays[indexPath.row].menuName else { return }
            menuNameLabel.text = menuName
            
            menuImageView.kf.setImage(with: URL(string: menuArrays[indexPath.row].menuImageUrl))
        }
    }
}
