//
//  PostViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/23.
//

import UIKit
import NCMB
import KRProgressHUD


class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet var postDataTableView: UITableView!
    
    @IBOutlet var postMenuImage: UIImageView!
    
    @IBOutlet var postMenuNameLabel: UILabel!
    
    @IBOutlet var totalPriceLabel: UILabel!
    
    @IBOutlet var totalCalorieLabel: UILabel!
    
    
    
    var selectedItems = [String]()
    
    var selctedToppings =  [String]()
    var customImageUrl = [String]()
    
    
    
    var passedMenu2: String!
    
    // 価格計算 初期値0
    var toppingsSumPrice = 0
    var menuSumPrice = 0
    var totalPrice = 0
    //　カロリー計算 初期値0
    var toppingsSumCalorie = 0
    var menuSumCalorie = 0
    var totalCalorie = 0
    
    var selectedMenu: NCMBObject!
    
    var menuNames = [String]()
    var menuImages = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        postDataTableView.rowHeight = 70
        postDataTableView.delegate = self
        postDataTableView.dataSource = self
        
        // nibの登録
        let nib = UINib(nibName: "PostTableViewCell", bundle: Bundle.main)
        postDataTableView.register(nib, forCellReuseIdentifier: "postCell")
        
        
        // ud領域を確保
        let ud = UserDefaults.standard
        // udのchoiceキーの中身を呼び出し、配列に格納
        if ud.array(forKey: "choice") != nil {
            selectedItems = ud.array(forKey: "choice") as! [String]
        } else {
            
        }
    
       
        UserDefaults.standard.removeObject(forKey: "choice")
        print(UserDefaults.standard.array(forKey: "choice"))
  
        
        
        // ud領域を確保
        let ud2 = UserDefaults.standard
        // udのselecrtedキーの中身(コレクションビューで選択された物)を呼び出す
        passedMenu2 = ud.string(forKey: "selected")
        print(passedMenu2)
        
        loadData()
        loadData2()
        
        print(selectedMenu)
        
    }
    

 
    // セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selctedToppings.count
        
    }
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
            
//        print(selctedToppings[indexPath.row])
        
        cell.passedCustomizeLabel.text = selctedToppings[indexPath.row]
        
        
        return cell
        
        
    }
    
    
    
    func loadData() {
        // custimoizeクラスを検索するNCMBQueryを作成
        let query = NCMBQuery(className: "customize")
        // custimzeカラムの選択された行を検索

        // 複数検索をかけることができる関数
        query?.whereKey("customize", containedIn: selectedItems)
        
        // 列のデータを取得
        query?.findObjectsInBackground({ (results, error) in
         
            if error != nil {

                // 失敗
//                print(error)
            } else {
                // 成功
               // print(results)
                // 結果をダウンキャスト。取り出したデータは一つであるが、形式上配列。
                let toppings = results as! [NCMBObject]
                // toppgingsの中身をfor文で回して中身を配列iに格納
                for i in toppings {
                    print(i)

                    let selectedCustomize = i.object(forKey: "customize") as! String
                    let customImageUrl = i.object(forKey: "image") as! String
//                    print(selectedCustomize)
            
                    // for文を回して選択するごとに値を足していく
                    // 価格計算
                    self.toppingsSumPrice += i.object(forKey: "price") as! Int
                    // カロリー計算
                    self.toppingsSumCalorie += i.object(forKey: "calorie") as! Int
                    

                    self.selctedToppings.append(selectedCustomize)
                    self.customImageUrl.append(customImageUrl)
                    print(self.selctedToppings)
                    

                    self.postDataTableView.reloadData()
                }
                
                print(self.toppingsSumPrice)
                print(self.toppingsSumCalorie)
                
                
                //print(self.selctedToppings)

            }
            
            


        })



    }
    
    func loadData2() {
        
        KRProgressHUD.show()
        
        // menuクラスを検索するNCMBQueryを作成
          let query = NCMBQuery(className: "menu")
        // menuクラスの選択され行のデータを検索を検索
          query?.whereKey("menu", equalTo: passedMenu2 as! String)
              // 列のデータを取得
        query?.findObjectsInBackground({ [self] (results, error) in
                  if error != nil {
                    // 失敗
                      print(error)
                 } else {
                    // 成功
                      print(results)
                    // 取り出した結果(results)をNCMB型にダウンキャストして変数に代入
                    // データは一つしかないが、形式的には配列
                  let menus = results as! [NCMBObject]
                    
                    for i in menus {
                        
                        let menuName = i.object(forKey: "menu")
                        let menuImage = i.object(forKey: "image")
                        
                        self.menuNames.append(menuName as! String)
                        self.menuImages.append(menuImage as! String)
                        
                    }

                        let menu = menus[0]
                         print(menu)
                    
            
                    
                    
                    
                    self.postMenuNameLabel.text = menu.object(forKey: "menu") as! String

                    self.menuSumPrice += menu.object(forKey: "price") as! Int

                    self.menuSumCalorie += menu.object(forKey: "calorie") as! Int
                    
                    let imageUrl = menu.object(forKey: "image") as! String
                        print(imageUrl)
                         // urlを変換
                        self.postMenuImage.kf.setImage(with:URL(string: imageUrl))
                        // 画像を読み込むための処理
                        KRProgressHUD.dismiss()
                        
                  }
              })
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        
        totalPrice += menuSumPrice
        totalPrice += toppingsSumPrice

        
        totalPriceLabel.text = String(totalPrice)

        totalCalorie += menuSumCalorie
        totalCalorie += toppingsSumCalorie
        
        totalCalorieLabel.text = String(totalCalorie)
        
        
        
    }
    
    @IBAction func sharePost() {
        
        KRProgressHUD.show()
        
        
        let postObject = NCMBObject(className: "post")
        
        // 配列からデータを取り出す
        let menuName = self.menuNames[0]
        let menuImage = self.menuImages[0]
        postObject?.setObject(menuName, forKey: "menuName")
        postObject?.setObject(menuImage, forKey: "menuImage")
        postObject?.setObject(totalPrice, forKey: "postPrice")
        postObject?.setObject(totalCalorie, forKey: "postCalorie")
        postObject?.setObject(selctedToppings, forKey: "toppings")
        postObject?.setObject(customImageUrl, forKey: "customImage")
        // ここをNCMBUser.current().userNameでやると取得できない
        postObject?.setObject(NCMBUser.current(), forKey: "userName")
        
        
        postObject?.saveInBackground({ (error) in
            
            if error != nil {
                print(error)
                
            } else {
                
                // 0番目のtabに戻る　＝　タイムライン
                self.tabBarController?.selectedIndex = 0
                self.dismiss(animated: true, completion: nil)
                // 三つ前のviewcontrollerに戻る
                let index = self.navigationController!.viewControllers.count - 4
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[index], animated: true)
              
            }
            
        })
        
        KRProgressHUD.dismiss()
        
        
        
        
    }
    

}

