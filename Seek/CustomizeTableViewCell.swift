//
//  CustomizeTableViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/19.
//

import UIKit

class CustomizeTableViewCell: UITableViewCell {
    
    @IBOutlet var customizeImageView: UIImageView!
    @IBOutlet var customizeNameLabel: UILabel!
    @IBOutlet var customCalorieLabel: UILabel!
    @IBOutlet var customPriceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
