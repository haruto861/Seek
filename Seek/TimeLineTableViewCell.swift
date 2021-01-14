//
//  TimeLineTableViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/29.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {
    

    
    @IBOutlet var userImage: UIImageView!
    
    // cellへアウトレット接続する
    @IBOutlet var selectedCustomizeCollectionView: UICollectionView!
   
    
    @IBOutlet var postCustomizeLabel: UILabel!
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postPriceLabel: UILabel!
    @IBOutlet var postCalorieLable: UILabel!
    @IBOutlet var postMenuNameLabel: UILabel!
    
    // セルに影をつけて浮かせる
    @IBOutlet var mainBackground: UIView!
    @IBOutlet var shadowLayer: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // xibファイルの登録
        let nib = UINib(nibName: "TimeLineCollectionViewCell", bundle: Bundle.main)
        selectedCustomizeCollectionView.register(nib, forCellWithReuseIdentifier: "CustomizeCell")
        
        //  画像の角を丸くするコード
        userImage.layer.cornerRadius = userImage.bounds.width / 2.0

        
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

    func setCollectionViewDataSourceDelegate
            <D: UICollectionViewDataSource & UICollectionViewDelegate>
            (dataSourceDelegate: D, forRow row: Int) {

        selectedCustomizeCollectionView.delegate = dataSourceDelegate
        selectedCustomizeCollectionView.dataSource = dataSourceDelegate
        selectedCustomizeCollectionView.tag = row
        selectedCustomizeCollectionView.reloadData()
        

        }
    

    
}
