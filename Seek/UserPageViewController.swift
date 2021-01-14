//
//  UserPageViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/10.
//

import UIKit
import NCMB
import KRProgressHUD

class UserPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var userImageview: UIImageView!
    
    @IBOutlet var userDisplayNameLabel: UILabel!
    
    @IBOutlet var timeLineTableView: UITableView!
    
    @IBOutlet  var  userIntroductionTextView: UITextView!
    
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
    
    var selectedIndex: IndexPath!
    
    var objectId: String!
    
    var blockUserIdArray = [String]()


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeLineTableView.rowHeight = 188
        
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController!.navigationBar.shadowImage = UIImage()
        
        userImageview.layer.cornerRadius = userImageview.bounds.width / 1.69
        
        userImageview.layer.masksToBounds = true
    
        self.timeLineTableView.dataSource = self
        self.timeLineTableView.delegate = self
        
        // nibの登録
        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: Bundle.main)
        // reuseセルとして登録
        timeLineTableView.register(nib, forCellReuseIdentifier: "TimeLineCell")
        


        loadData()
        getBlockUser()
        
    }
    
    // 表示されるセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    
        
        
    }
    // 表示されるセルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  UItableViewCell型に変換して代入
        
        selectedIndex = indexPath
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as! TimeLineTableViewCell
        
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        

        cell.postPriceLabel.text = posts[indexPath.row].totalPrice
        cell.postCalorieLable.text = posts[indexPath.row].totalCalorie
        cell.postMenuNameLabel.text = posts[indexPath.row].menuName
        
       
      
        
        print(posts[indexPath.row].menuImage!,"self")
        cell.postImage.kf.setImage(with: URL(string: self.posts[indexPath.row].menuImage!))
        
        let user = posts[indexPath.row].user
        
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/LwINpgUX9Mz5et6L/publicFiles/" + user!.objectId
              cell.userImage.kf.setImage (with: URL (string: userImageUrl), placeholder: UIImage (named: "placeholder.jpg"))
        
        cell.userNameLabel.text = user?.userName
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        guard let cell = cell as? TimeLineTableViewCell else { return }

        //ShopTableViewCell.swiftで設定したメソッドを呼び出す
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = NCMBUser.current() {
            userDisplayNameLabel.text = user.object(forKey: "displayName") as? String
            userIntroductionTextView.text = user.object(forKey: "introduction") as? String
            self.navigationItem.title = user.userName
            let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: nil) as! NCMBFile
            file.getDataInBackground { [self] (data, error) in
                if error != nil {
                    print(error)
                } else{
                    if data != nil {
                        let image = UIImage(data: data!)
                        self.userImageview.image = image
                        
                    }
                }
            }
        } else {
            // NCMBUser.current()がnilだったとき
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            // ログイン状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
            
    }
            
    
    
    @IBAction func showMenu() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択して下さい。", preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground({ (error) in
                if error != nil {
//                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    // ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    // ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            
            let alert = UIAlertController(title: "会員登録の解除", message: "本当に退会しますか？退会した場合、再度このアカウントをご利用頂くことができません。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                // ユーザーのアクティブ状態をfalseに
                if let user = NCMBUser.current() {
                    user.setObject(false, forKey: "active")
                    user.saveInBackground({ (error) in
                        if error != nil {
//                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            // userのアクティブ状態を変更できたらログイン画面に移動
                            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                            UIApplication.shared.keyWindow?.rootViewController = rootViewController
                            
                            // ログイン状態の保持
                            let ud = UserDefaults.standard
                            ud.set(false, forKey: "isLogin")
                            ud.synchronize()
                        }
                    })
                } else {
                    // userがnilだった場合ログイン画面に移動
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    // ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
                
            })
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    
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
                //self.comments.remove(at: indexPath.row)
                //tableView.deleteRows(at: [indexPath], with: .fade)
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

                           //ここで③を読み込んでいる
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
            deleteButton.backgroundColor = UIColor.red //色変更
            return [deleteButton]
        }
    }


// ③ ブロックしたユーザーを持ってくる
func getBlockUser() {
        // ブロッククラスに検索をかける
        let query = NCMBQuery(className: "Block")
        //includeKeyでBlockの子クラスである会員情報を持ってきている
        query?.includeKey("user")
        // ユーザーが自分と一致した場合
        query?.whereKey("user", equalTo: NCMBUser.current())
        //　データを検索
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //エラーの処理
            } else {
                //ブロックされたユーザーのIDが含まれる + removeall()は初期化していて、データの重複を防いでいる
                self.blockUserIdArray.removeAll()
                print(result)
                for blockObject in result as! [NCMBObject] {
                    //この部分で①の配列にブロックユーザー情報が格納
self.blockUserIdArray.append(blockObject.object(forKey: "blockUserID") as! String)

                }

            }
        })
    
        loadData()
    }

//②
func loadData() {
    
//ここにNCMBから値を持ってくるコードが書いてある前提
    let query = NCMBQuery(className: "post")
    
    query?.order(byDescending: "createDate")
    
    query?.includeKey("userName")
    
    query?.whereKey("userName", equalTo: NCMBUser.current())
    
    query?.findObjectsInBackground({ (results, error) in
        
        if error != nil {
            
            print(error)
        } else {
            print(results)
            
            self.posts = [Post]()
            
            for i in results as! [NCMBObject] {

                print(i)

                guard  let user  = i.object(forKey: "userName") as?  NCMBUser else {

                    return
                }
                user.userName = user.object(forKey: "userName") as! String

                let userModel = User(objectId: user.objectId, userName: user.userName)


                self.menuName = i.object(forKey: "menuName") as! String
                // 初めにurlを取得して、kingfisherで引っ張ってくる
                self.menuImageUrl = i.object(forKey: "menuImage") as! String
                // カスタマイズの画像urlも同様に取得
                self.customImageUrl = i.object(forKey: "customImage") as! [String]
                
                

                self.postedCustomizes = i.object(forKey: "toppings") as! [String]
                print(self.postedCustomizes)

        
                self.prePostCalorie = i.object(forKey: "postCalorie") as! Int
                self.postCalorie = String(self.prePostCalorie)

                self.prePostPrice = i.object(forKey: "postPrice") as! Int
                self.postPrice = String(self.prePostPrice)
                
                self.objectId = i.object(forKey: "objectId") as! String


                //appendする時に、ブロックユーザーがnilであったらappendされるようにしている。
                let post = Post(menuName: self.menuName, user: userModel, menuImage: self.menuImageUrl, totalPrice: self.postPrice, totalCalorie: self.postCalorie, createDate: i.createDate, toppings: self.postedCustomizes, customImage: self.customImageUrl, objectId: self.objectId)

                if self.blockUserIdArray.firstIndex(of: post.user.objectId) == nil{
                                            self.posts.append(post)
                               }
                
            }

        }
        
        self.timeLineTableView.reloadData()
        
    })

}


}



  extension UserPageViewController: UICollectionViewDataSource, UICollectionViewDelegate{
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return  postedCustomizes.count
 }
 
 

 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomizeCell", for: indexPath) as! TimeLineCollectionViewCell
    

         
     cell.selectedCusomizeLabel.text = postedCustomizes[indexPath.row]
         print(postedCustomizes[indexPath.row])
    
    cell.selectedCustomizeImage.kf.setImage(with: URL(string: customImageUrl[indexPath.row]))
    
    
         

     return cell

 }
}

