//
//  TimeLineViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/29.
//

import UIKit
import NCMB
import Kingfisher
import KRProgressHUD

class TimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private var timeLineTableView: UITableView!
    private var posts =  [Post]()
    private var customizes = [String]()
    private var customImageUrls = [String]()
    private var blockUserIdArray = [String]()
    private var objectId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        timeLineTableView.rowHeight = 188
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        timeLineTableView.separatorStyle = .none

        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: Bundle.main)
        timeLineTableView.register(nib, forCellReuseIdentifier: "TimeLineTableViewCell")
        setRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        getBlockUser()
        loadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineTableViewCell") as! TimeLineTableViewCell
        let user = posts[indexPath.row].user!
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/LwINpgUX9Mz5et6L/publicFiles/" + user.objectId
        cell.configure(allPost: posts[indexPath.row], user: user, userImageUrl: userImageUrl)
        return cell
    }

    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        timeLineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TimeLineTableViewCell else { return }
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }


    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if posts[indexPath.row].user.objectId != NCMBUser.current()?.objectId {
            let reportButton = self.buttonAction(buttonTitle: "報告", selectedAction: self.reportAction(repotId: posts[indexPath.row].objectId), alertTitle: "報告", message: "投稿を報告しますか")
            reportButton.backgroundColor = UIColor.red
            let blockButton = buttonAction(buttonTitle: "ブロック", selectedAction: self.blockAction(blockId: posts[indexPath.row].user.objectId), alertTitle: "ブロック", message: "ブロックしますか")
            blockButton.backgroundColor = UIColor.blue
            return[blockButton,reportButton]
        } else {
            let deleteButton  = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
                let query = NCMBQuery(className: "post")
                query?.getObjectInBackground(withId: self.posts[indexPath.row].objectId, block: { (post, error) in
                    guard (error == nil) else {
                        KRProgressHUD.showError(withMessage: "エラーです")
                        KRProgressHUD.show()
                        return
                    }
                    DispatchQueue.main.async {
                        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in }
                        let deleteAction = self.deleteAction(post: post!)
                        tableView.deselectRow(at: index, animated: true)
                        self.showAlert(title: "投稿を削除しますか", message: "削除します", preferredStyle: .alert, actions: [cancelAction, deleteAction])
                        tableView.isEditing = false
                    }
                })
            }
            deleteButton.backgroundColor = UIColor.red
            return [deleteButton]
        }
    }

    private func buttonAction(buttonTitle: String, selectedAction: UIAlertAction, alertTitle: String, message: String) -> UITableViewRowAction {
        let button = UITableViewRowAction(style: .normal, title: buttonTitle) { (action, index) -> Void in
            let selectedAction = selectedAction
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in }
            self.showAlert(title: "ブロック", message: "ブロックしますか", preferredStyle: .actionSheet, actions: [selectedAction, cancelAction])
        }
        return button
    }

    private func reportAction(repotId: String) -> UIAlertAction {
        let reportAction = UIAlertAction(title: "報告する", style: .destructive ){ (action) in
            KRProgressHUD.showSuccess(withMessage: "この投稿を報告しました。ご協力ありがとうございました。")
            let object = NCMBObject(className: "Report")
            object?.setObject(repotId, forKey: "reportId")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                guard (error == nil) else {
                    KRProgressHUD.showError(withMessage: "エラーです")
                    return
                }
                KRProgressHUD.dismiss()
            })
        }
        return reportAction
    }

    private func blockAction(blockId: String) -> UIAlertAction {
        let blockAction = UIAlertAction(title: "ブロックする", style: .destructive) { (action) in
            KRProgressHUD.showSuccess(withMessage: "このユーザーをブロックしました。")
            let object = NCMBObject(className: "Block")
            object?.setObject(blockId, forKey: "blockUserID")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                guard (error == nil) else {
                    KRProgressHUD.showError(withMessage: "エラーです")
                    return
                }
                KRProgressHUD.dismiss()
                self.getBlockUser()
            })
        }
        return blockAction
    }

    private func deleteAction(post: NCMBObject) -> UIAlertAction {
        let deleteAction = UIAlertAction(title: "OK", style: .default) { (acrion) in
            post.deleteInBackground({ (error) in
                guard (error == nil) else {
                    KRProgressHUD.showError(withMessage: "エラーです")
                    KRProgressHUD.dismiss()
                    return
                }
                KRProgressHUD.showSuccess(withMessage: "削除完了")
                self.loadData()
                self.timeLineTableView.reloadData()
            })
        }
        return deleteAction
    }

    private func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style , actions: [UIAlertAction]) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: preferredStyle )
        actions.forEach {alert.addAction($0)}
        present(alert, animated: true, completion: nil)
    }

    private func getBlockUser() {
        let query = NCMBQuery(className: "Block")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
            } else {
                self.blockUserIdArray.removeAll()
                for blockObject in result as? [NCMBObject] ?? [] {
                    self.blockUserIdArray.append(blockObject.object(forKey: "blockUserID") as? String ?? "")
                }
            }
        })
        loadData()
    }
    
    private func loadData() {
        let query = NCMBQuery(className: "post")
        query?.order(byDescending: "createDate")
        query?.includeKey("userName")
        query?.findObjectsInBackground({ (results, error) in
            guard let postDatas = results as? [NCMBObject]  else { return }
            self.setData(datas: postDatas)
            for postData in postDatas {
                guard let user  = postData.object(forKey: "userName") as? NCMBUser else { return }
                guard let menuName = postData.object(forKey: "menuName") as? String else { return }
                guard let menuImageUrl = postData.object(forKey: "menuImage") as? String else { return }
                guard let prePostCalorie = postData.object(forKey: "postCalorie") as? Int else { return }
                guard let prePostPrice = postData.object(forKey: "postPrice") as? Int else { return }
                user.userName = user.object(forKey: "userName") as? String
                let userModel = User(objectId: user.objectId, userName: user.userName)
                let postPrice = "\(prePostPrice)"
                let postCalorie = "\(prePostCalorie)"
                self.customImageUrls = postData.object(forKey: "customImage") as? [String] ?? []
                self.customizes = postData.object(forKey: "toppings") as? [String] ?? []
                self.objectId = postData.object(forKey: "objectId") as? String
                // 初期化している
                let post = Post(menuName: menuName, user: userModel, menuImage: menuImageUrl, totalPrice: postPrice, totalCalorie: postCalorie, createDate: postData.createDate, toppings: self.customizes, customImage: self.customImageUrls, objectId: self.objectId)

                if self.blockUserIdArray.firstIndex(of: post.user.objectId) == nil {
                    self.posts.append(post)
                }
            }
            self.timeLineTableView.reloadData()
        })
    }

    func setData(datas: [NCMBObject]) {
    }


}

extension TimeLineViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if customizes.isEmpty {
            return 0
        } else {
            return customizes.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeLineCollectionViewCell.id, for: indexPath) as? TimeLineCollectionViewCell else {
            abort()
        }
        cell.indexPath = indexPath
        cell.customize = customizes
        cell.customizeImage = customImageUrls
        return cell
    }

}
