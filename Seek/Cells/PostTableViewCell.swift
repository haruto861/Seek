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
    var customizeMenuNames =  [String]()
    var customizeArray = [Customize]()
    var indexPath:IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        if customizeArray.count > 0  {
            print(customizeArray)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
