//
//  TimeLineTableViewCell.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/29.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {
    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet private var selectedCustomizeCollectionView: UICollectionView!
    @IBOutlet weak var postUserNameLabel: UILabel!
    @IBOutlet weak var postMenuImage: UIImageView!
    @IBOutlet weak var postPriceLabel: UILabel!
    @IBOutlet weak var postCalorieLable: UILabel!
    @IBOutlet weak var postMenuNameLabel: UILabel!

    var post = [Post]()
    var indexPath: IndexPath?

    @IBOutlet private var mainBackground: UIView!
    @IBOutlet private var shadowLayer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainBackground.layer.cornerRadius = 8
        self.mainBackground.layer.masksToBounds = true
        self.backgroundColor = .systemGray6
        let nib = UINib(nibName: "TimeLineCollectionViewCell", bundle: Bundle.main)
        selectedCustomizeCollectionView.register(nib, forCellWithReuseIdentifier: "CustomizeCell")
        postUserImage.layer.cornerRadius = postUserImage.bounds.width / 2.0
    }

    override func layoutSubviews() {
        guard let indexPath = indexPath else { return }
        postPriceLabel.text = post[indexPath.row].totalPrice
        postCalorieLable.text = post[indexPath.row].totalCalorie
        postMenuNameLabel.text = post[indexPath.row].menuName
        guard let user = post[indexPath.row].user else { return }
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/LwINpgUX9Mz5et6L/publicFiles/" + user.objectId
        postUserNameLabel.text = user.userName
        self.postUserImage.kf.setImage (with: URL (string: userImageUrl), placeholder: UIImage (named: "placeholder.jpg"))
        self.postMenuImage.kf.setImage(with: URL(string: self.post[indexPath.row].menuImage!))
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
