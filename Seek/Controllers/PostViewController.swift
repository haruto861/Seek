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
            selectedItems = ud.array(forKey: "choice") as? [String] ?? []
        } else {
        }
        UserDefaults.standard.removeObject(forKey: "choice")
        print(UserDefaults.standard.array(forKey: "choice"))
        // ud領域を確保
        let ud2 = UserDefaults.standard
        // udのselecrtedキーの中身(コレクションビューで選択された物)を呼び出す
        passedMenu2 = ud.string(forKey: "selected")
        let ud3 = UserDefaults.standard
        menuSumCalorie += ud.integer(forKey: "menuCalorie")
        menuSumPrice += ud.integer(forKey: "menuPrice")
        print(menuSumCalorie)
        print(menuSumPrice)

        loadData()
        loadData2()
    }
    // セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selctedToppings.count
    }
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostTableViewCell else {
            abort()
        }
        cell.passedCustomizeLabel.text = selctedToppings[indexPath.row]
        return cell
    }
    func loadData() {
        let query = NCMBQuery(className: "customize")
        query?.whereKey("customize", containedIn: selectedItems)
        query?.findObjectsInBackground({ (results, error) in
            if error != nil {
            } else {
                let toppings = results as? [NCMBObject] ?? []
                for text in toppings {
                    print(text)
                    let selectedCustomize = text.object(forKey: "customize") as? String ?? ""
                    let customImageUrl = text.object(forKey: "image") as? String ?? ""
                    // for文を回して選択するごとに値を足していく
                    // 価格計算
                    self.toppingsSumPrice += text.object(forKey: "price") as? Int ?? 0
                    // カロリー計算
                    self.toppingsSumCalorie += self.menuSumCalorie
                    self.selctedToppings.append(selectedCustomize)
                    self.customImageUrl.append(customImageUrl)
                    print(self.selctedToppings)
                    self.postDataTableView.reloadData()
                }
                print(self.toppingsSumPrice)
                print(self.toppingsSumCalorie)
            }
        })
    }

    func loadData2() {
        KRProgressHUD.show()
          let query = NCMBQuery(className: "menu")
          query?.whereKey("menu", equalTo: passedMenu2 as? String ?? "")
        query?.findObjectsInBackground({ [self] (results, error) in
                  if error != nil {
                 } else {
                  let menus = results as? [NCMBObject] ?? []
                    
                    for text in menus {
                        let menuName = text.object(forKey: "menu")
                        let menuImage = text.object(forKey: "image")
                        self.menuNames.append(menuName as? String ?? "")
                        self.menuImages.append(menuImage as? String ?? "")
                    }
                    let menu = menus[0]
                         print(menu)
                    self.postMenuNameLabel.text = menu.object(forKey: "menu") as? String ?? ""
                    self.menuSumPrice += menu.object(forKey: "price") as? Int ?? 0
                    self.menuSumCalorie += menu.object(forKey: "calorie") as? Int ?? 0
                    let imageUrl = menu.object(forKey: "image") as? String ?? ""
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
    
    @IBAction private func sharePost() {
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
        postObject?.setObject(NCMBUser.current(), forKey: "userName")
        postObject?.saveInBackground({ (error) in
            if error != nil {
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
