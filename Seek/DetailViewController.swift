//
//  DetailViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/19.
//

import UIKit
import NCMB
import Kingfisher
import KRProgressHUD


class DetailViewController: UIViewController {
    
    @IBOutlet var passedMenuImage: UIImageView!
    // 画像データの受け皿
    var selectedImage: UIImage!
    
    @IBOutlet var passedMenuNameLabel: UILabel!
    @IBOutlet var passedCalorieLabel: UILabel!
    @IBOutlet var passedPriceLabel: UILabel!
    
    // カロリー、価格の受け皿を用意
    var passedCalorie = 0
    var passedPrice = 0
    
    
    
    
    //  データの受け皿を作成
    var passedData: NCMBObject!
    
    var passedMenu: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // データが渡されているかを確認
        print(passedData)


        passedMenuNameLabel.text = passedData.object(forKey: "menu") as? String
        passedCalorieLabel.text = passedData.object(forKey: "calorie") as? String
        passedPriceLabel.text = passedData.object(forKey: "price") as? String
        
        // 選択されたメニューの価格とカロリーをInt方
        let postCalorie = passedData.object(forKey: "calorie") as? String
        print(postCalorie)
        let postPrice =  passedData.object(forKey: "price") as? String
        print(postPrice)
        
//        passedMenuImage.image = selectedImage
        
        
        // ud領域を確保
        let ud = UserDefaults.standard
        // udのselecrtedキーの中身(コレクションビューで選択された物)を呼び出す
        passedMenu = ud.string(forKey: "selected")
        print(passedMenu)
        
        

        loadData()
       
        
    }
        

    
    @IBAction func back() {
        // 戻るコード
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toCustomize() {
        // idetifierが"toDetail"のsegueを使って画面遷移する関数
        performSegue(withIdentifier: "toCustomize", sender: nil)
        
    }
    
    func loadData() {
        
        KRProgressHUD.show()
        
        
        // menuクラスを検索するNCMBQueryを作成
          let query = NCMBQuery(className: "menu")
        // menuクラスの選択され行のデータを検索
          query?.whereKey("menu", equalTo: passedMenu as! String)
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
                    // 配列の一つ目のデータを取り出す

                    let menu = menus[0]
                    self.passedPrice += menu.object(forKey: "price") as! Int
                    self.passedPriceLabel.text = String(self.passedPrice)
                    
                    self.passedCalorie += menu.object(forKey: "calorie") as! Int
                    self.passedCalorieLabel.text = String(self.passedCalorie)
                    
                    let imageUrl = menu.object(forKey: "image") as! String
                        print(imageUrl)
                         // urlを変換
                        self.passedMenuImage.kf.setImage(with:URL(string: imageUrl))
                        // 画像を読み込むための処理
                        KRProgressHUD.dismiss()
                        
              
                  


                  }
              })
        
        
        
        
        
    }
    

    
    
    


}
