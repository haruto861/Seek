//
//  PostTableViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/29.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet var passedCustomizeLabel: UILabel!
    @IBOutlet var passeMenuImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
