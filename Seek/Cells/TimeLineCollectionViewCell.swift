//
//  TimeLineCollectionViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/11/16.
//

import UIKit

class TimeLineCollectionViewCell: UICollectionViewCell {
    @IBOutlet  weak var selectedCusomizeLabel: UILabel!
    @IBOutlet  weak var selectedCustomizeImage: UIImageView!
    var customize = [String]()
    var customizeImage = [String]()
    var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        selectedCusomizeLabel.text = ""
        selectedCustomizeImage.image = nil
    }

    override func layoutSubviews() {
        guard let indexPath = indexPath else { return }
        let customizeArray = customize
        selectedCusomizeLabel.text = customizeArray[indexPath.row]
        let customizeImageArray = customizeImage
        selectedCustomizeImage.kf.setImage(with: URL(string: customizeImageArray[indexPath.row]))
        
        
    }

}
