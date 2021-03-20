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
    
    
    @IBOutlet var timeLineTableView: UITableView!
    
    var posts =  [Post]()
    
    var prePostCalorie = 0
    var prePostPrice = 0
    
    var postCalorie: String!
    var postPrice: String!
    var menuName: String!
    var menuImageUrl: String!
    var prePostImage: UIImage!
    var postedCustomizes = [String]()
    var customImageUrl = [String]()
    // 二重配列
    var postCustom = [[String]]()
    var postCustomImage = [[String]]()
    var selctedIndex: IndexPath!
    var selectedIndex2 : IndexPath!
    // ブロックしたユーザーのIdを格納する変数
    var blockUserIdArray = [String]()
    var objectId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController!.navigationBar.shadowImage = UIImage()
        
        // セルが潰れないように高さを設定
        timeLineTableView.rowHeight = 188
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        
        // 区切り線をなくす
        timeLineTableView.separatorStyle = .none

        // nibの登録
        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: Bundle.main)
        // reuseセルとして登録
        timeLineTableView.register(nib, forCellReuseIdentifier: "TimeLineCell")
        
        setRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        getBlockUser()
        loadData()
    }
    
    // 表示されるセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    // 表示されるセルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  UItableViewCell型に変換して代入
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineTableViewCell else {
            abort()

        }
        
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.backgroundColor = .systemGray6
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
        self.selctedIndex = indexPath

        cell.postPriceLabel.text = posts[indexPath.row].totalPrice
        cell.postCalorieLable.text = posts[indexPath.row].totalCalorie
        cell.postMenuNameLabel.text = posts[indexPath.row].menuName
        
        let user = posts[indexPath.row].user
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/LwINpgUX9Mz5et6L/publicFiles/" + user!.objectId
              cell.userImage.kf.setImage (with: URL (string: userImageUrl), placeholder: UIImage (named: "placeholder.jpg"))
        cell.userNameLabel.text = user?.userName
        print(posts[indexPath.row].menuImage!,"self")
        cell.postImage.kf.setImage(with: URL(string: self.posts[indexPath.row].menuImage!))
        return cell
    }

    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        timeLineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TimeLineTableViewCell else { return }
        // ShopTableViewCell.swiftで設定したメソッドを呼び出す
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    // ① 自分以外＝>報告・ブロックする
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            // 選択した投稿のobjectIdが自分のと異なっていた場合
            if posts[indexPath.row].user.objectId != NCMBUser.current()?.objectId {
                let reportButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "報告") { (action, index) -> Void in
                    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let reportAction = UIAlertAction(title: "報告する", style: .destructive ){ (action) in
                        KRProgressHUD.showSuccess(withMessage: "この投稿を報告しました。ご協力ありがとうございました。")
                        // 新たにクラスを作成する
                        let object = NCMBObject(className: "Report")
                        // "reportId"に選択したセルのobjectIdをセットする
                        object?.setObject(self.posts[indexPath.row].objectId, forKey: "reportId")
                        // "user"に自分自身のユーザーデータをセット
                        object?.setObject(NCMBUser.current(), forKey: "user")
                        // それらを保存する
                        object?.saveInBackground({ (error) in
                            if error != nil {
                                KRProgressHUD.showError(withMessage: "エラーです。")
                            } else {
                                KRProgressHUD.dismiss()
                                tableView.deselectRow(at: indexPath, animated: true)
                            }
                        })
                    }
                    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    }

                    alertController.addAction(reportAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    tableView.isEditing = false

                }
                reportButton.backgroundColor = UIColor.red
                let blockButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "ブロック") { (action, index) -> Void in
                    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let blockAction = UIAlertAction(title: "ブロックする", style: .destructive) { (action) in
                        KRProgressHUD.showSuccess(withMessage: "このユーザーをブロックしました。")
                        // Blockのクラスを作成
                        let object = NCMBObject(className: "Block")
                        // 選択されたセルのobjectIdを"blockuserId"にセットする
                        object?.setObject(self.posts[indexPath.row].user.objectId, forKey: "blockUserID")
                        // 選択したセルのユーザーデータを"user"にセットする
                        object?.setObject(NCMBUser.current(), forKey: "user")
                        // それらを保存する
                        object?.saveInBackground({ (error) in
                            if error != nil {
                                KRProgressHUD.showError(withMessage: "エラーです")
                            } else {
                                KRProgressHUD.dismiss()
                                tableView.deselectRow(at: indexPath, animated: true)
                               // ここで③を読み込んでいる
                                self.getBlockUser()
                            }
                        })

                    }
                    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    }

                    alertController.addAction(blockAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    tableView.isEditing = false
                }
                blockButton.backgroundColor = UIColor.blue
                return[blockButton,reportButton]
            } else {
                let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
                    let query = NCMBQuery(className: "post")
                    query?.getObjectInBackground(withId: self.posts[indexPath.row].objectId, block: { (post, error) in
                        if error != nil {
                            KRProgressHUD.showError(withMessage: "エラーです")
                            KRProgressHUD.show()

                        } else {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "投稿を削除しますか？", message: "削除します", preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                                    alertController.dismiss(animated: true, completion: nil)
                                }
                                let deleteAction = UIAlertAction(title: "OK", style: .default) { (acrion) in
                                    post?.deleteInBackground({ (error) in
                                        if error != nil {
                                            KRProgressHUD.showError(withMessage: "エラーです")
                                            KRProgressHUD.dismiss()

                                        } else {
                                            tableView.deselectRow(at: indexPath, animated: true)
                                            self.loadData()
                                            self.timeLineTableView.reloadData()
                                        }
                                    })
                                }
                                alertController.addAction(cancelAction)
                                alertController.addAction(deleteAction)
                                self.present(alertController,animated: true,completion: nil)
                                tableView.isEditing = false
                            }

                        }
                    })
                }
                deleteButton.backgroundColor = UIColor.red // 色変更
                return [deleteButton]
            }
        }
    // ③ ブロックしたユーザーを持ってくる
    func getBlockUser() {
            // ブロッククラスに検索をかける
            let query = NCMBQuery(className: "Block")
            // bincludeKeyでBlockの子クラスである会員情報を持ってきている
            query?.includeKey("user")
            // ユーザーが自分と一致した場合
            query?.whereKey("user", equalTo: NCMBUser.current())
            //　データを検索
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    // エラーの処理
                } else {
                    // ブロックされたユーザーのIDが含まれる + removeall()は初期化していて、データの重複を防いでいる
                    self.blockUserIdArray.removeAll()
                    print(result)
                    for blockObject in result as? [NCMBObject] ?? [] {
                        // この部分で①の配列にブロックユーザー情報が格納
    self.blockUserIdArray.append(blockObject.object(forKey: "blockUserID") as? String ?? "")
                    }

                }
            })
        loadData()
        }
    // ②
    func loadData() {
    // ここにNCMBから値を持ってくるコードが書いてある前提
        let query = NCMBQuery(className: "post")
        query?.order(byDescending: "createDate")
        query?.includeKey("userName")
        query?.findObjectsInBackground({ (results, error) in
            
            if error != nil {
                print(error)
            } else {
                print(results)
                self.posts = [Post]()
                for text in results as? [NCMBObject] ?? [] {
                    guard  let user  = text.object(forKey: "userName") as? NCMBUser else {

                        return
                    }
                    user.userName = user.object(forKey: "userName") as? String

                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    self.menuName = text.object(forKey: "menuName") as? String
                    // 初めにurlを取得して、kingfisherで引っ張ってくる
                    self.menuImageUrl = text.object(forKey: "menuImage") as? String
                    // カスタマイズの画像urlも同様に取得
                    self.customImageUrl = text.object(forKey: "customImage") as? [String] ?? []
                    self.postedCustomizes = text.object(forKey: "toppings") as? [String] ?? []
                    print(self.postedCustomizes)
                    self.prePostCalorie = text.object(forKey: "postCalorie") as? Int ?? 0
                    self.postCalorie = String(self.prePostCalorie)
                    self.prePostPrice = text.object(forKey: "postPrice") as? Int ?? 0
                    self.postPrice = String(self.prePostPrice)
                    self.objectId = text.object(forKey: "objectId") as? String
                    // appendする時に、ブロックユーザーがnilであったらappendされるようにしている。
                    let post = Post(menuName: self.menuName, user: userModel, menuImage: self.menuImageUrl, totalPrice: self.postPrice, totalCalorie: self.postCalorie, createDate: text.createDate, toppings: self.postedCustomizes, customImage: self.customImageUrl, objectId: self.objectId)

                    if self.blockUserIdArray.firstIndex(of: post.user.objectId) == nil {
                        self.posts.append(post)

                    }
                }

            }
            self.timeLineTableView.reloadData()
        })

    }
}
   extension TimeLineViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts[selctedIndex.row].toppings.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomizeCell", for: indexPath) as? TimeLineCollectionViewCell else {
            abort()

        }
        cell.selectedCusomizeLabel.text = posts[selctedIndex.row].toppings[indexPath.row]
        cell.selectedCustomizeImage.kf.setImage(with: URL(string: posts[selctedIndex.row].customImage[indexPath.row]))
        return cell
    }
}
