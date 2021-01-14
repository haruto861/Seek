//
//  PostTableViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/29.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet var passedCustomizeLabel: UILabel!
    
//    @IBOutlet var paseedCalorieLabel: UILabel!
    
//    @IBOutlet var passedPriceLabel: UILabel!
    
    @IBOutlet var passeMenuImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
