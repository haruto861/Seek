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

    var tableViewIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLineTableView.rowHeight = 188
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        timeLineTableView.separatorStyle = .none

        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: Bundle.main)
        timeLineTableView.register(nib, forCellReuseIdentifier: "TimeLineCell")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineTableViewCell else {
            abort()
        }
        cell.post = posts
        cell.indexPath = indexPath
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
            let reportButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "報告") { (action, index) -> Void in
                let reportAction = UIAlertAction(title: "報告する", style: .destructive ){ (action) in
                    KRProgressHUD.showSuccess(withMessage: "この投稿を報告しました。ご協力ありがとうございました。")
                    let object = NCMBObject(className: "Report")
                    object?.setObject(self.posts[indexPath.row].objectId, forKey: "reportId")
                    object?.setObject(NCMBUser.current(), forKey: "user")
                    object?.saveInBackground({ (error) in
                        guard (error == nil) else {
                            KRProgressHUD.showError(withMessage: "エラーです")
                            return
                        }
                        KRProgressHUD.dismiss()
                        tableView.deselectRow(at: indexPath, animated: true)
                        })
                    }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                }
                self.showAlert(title: "報告", message: "投稿を報告しますか", preferredStyle: .actionSheet, actions: [reportAction, cancelAction])
                tableView.isEditing = false
            }
            reportButton.backgroundColor = UIColor.red
            let blockButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "ブロック") { (action, index) -> Void in
                let blockAction = UIAlertAction(title: "ブロックする", style: .destructive) { (action) in
                    KRProgressHUD.showSuccess(withMessage: "このユーザーをブロックしました。")
                    let object = NCMBObject(className: "Block")
                    object?.setObject(self.posts[indexPath.row].user.objectId, forKey: "blockUserID")
                    object?.setObject(NCMBUser.current(), forKey: "user")
                    object?.saveInBackground({ (error) in
                        guard (error == nil) else {
                            KRProgressHUD.showError(withMessage: "エラーです")
                            return
                        }
                        KRProgressHUD.dismiss()
                        self.getBlockUser()
                        tableView.deselectRow(at: indexPath, animated: true)
                        })
                    }
                    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    }
                self.showAlert(title: "ブロック", message: "ブロックしますか", preferredStyle: .actionSheet, actions: [blockAction, cancelAction])
                    tableView.isEditing = false
                }
                blockButton.backgroundColor = UIColor.blue
                return[blockButton,reportButton]
        } else {
            let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
                let query = NCMBQuery(className: "post")
                query?.getObjectInBackground(withId: self.posts[indexPath.row].objectId, block: { (post, error) in
                    guard (error == nil) else {
                        KRProgressHUD.showError(withMessage: "エラーです")
                        KRProgressHUD.show()
                            return
                    }
                    DispatchQueue.main.async {
                        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in }
                        let deleteAction = UIAlertAction(title: "OK", style: .default) { (acrion) in
                                post?.deleteInBackground({ (error) in
                                        guard (error != nil) else {
                                            tableView.deselectRow(at: indexPath, animated: true)
                                            self.loadData()
                                            self.timeLineTableView.reloadData()
                                            return
                                        }
                                        KRProgressHUD.showError(withMessage: "エラーです")
                                        KRProgressHUD.dismiss()
                                    })
                                }
                        self.showAlert(title: "投稿を削除しますか", message: "削除します", preferredStyle: .alert, actions: [cancelAction, deleteAction])
                        tableView.isEditing = false
                    }
                    })
                }
                deleteButton.backgroundColor = UIColor.red 
                return [deleteButton]
            }
        }


    // リファクタリング
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style , actions: [UIAlertAction]) {
        let alert  = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        // $0が要素
        actions.forEach {alert.addAction($0)}
        present(alert, animated: true, completion: nil)
    }



    func getBlockUser() {
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


    func loadData() {
        let query = NCMBQuery(className: "post")
        query?.order(byDescending: "createDate")
        query?.includeKey("userName")
        query?.findObjectsInBackground({ (results, error) in
            self.posts = [Post]()
            guard let postDatas = results as? [NCMBObject]  else { return }
            for postData in postDatas {
                guard let user  = postData.object(forKey: "userName") as? NCMBUser else { return }
                user.userName = user.object(forKey: "userName") as? String
                let userModel = User(objectId: user.objectId, userName: user.userName)
                guard let menuName = postData.object(forKey: "menuName") as? String else { return }
                guard let menuImageUrl = postData.object(forKey: "menuImage") as? String else { return }
                guard let prePostCalorie = postData.object(forKey: "postCalorie") as? Int else { return }
                let postCalorie = "\(prePostCalorie)"
                guard let prePostPrice = postData.object(forKey: "postPrice") as? Int else { return }
                let postPrice = "\(prePostPrice)"
                self.customImageUrls = postData.object(forKey: "customImage") as? [String] ?? []
                self.customizes = postData.object(forKey: "toppings") as? [String] ?? []
                self.objectId = postData.object(forKey: "objectId") as? String
                let post = Post(menuName: menuName, user: userModel, menuImage: menuImageUrl, totalPrice: postPrice, totalCalorie: postCalorie, createDate: postData.createDate, toppings: self.customizes, customImage: self.customImageUrls, objectId: self.objectId)
                    if self.blockUserIdArray.firstIndex(of: post.user.objectId) == nil {
                        self.posts.append(post)
                    }
                }
            self.timeLineTableView.reloadData()
        })
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomizeCell", for: indexPath) as? TimeLineCollectionViewCell else {
            abort()
        }
        cell.indexPath = indexPath
        cell.customize = customizes
        cell.customizeImage = customImageUrls
        return cell
    }
}
