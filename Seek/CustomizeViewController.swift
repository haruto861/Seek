//
//  CustomizeViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/19.
//

import UIKit
import NCMB


class CustomizeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //カスタムメニューを入れる変数
    var customizes = ["エスプレッソショット","バニラシロップ", "キャラメルシロップ","クラシックシロップ", "アーモンドトフィーシロップ","チョコレートシロップ", "ホワイトモカシロップ","チャイシロップ", "ホイップクリーム","チョコレートチップ", "キャラメルソース","チョコレートソース","シトラス果肉"]
    var calories = ["5","19", "19","21", "22","48", "53","34", "89","54", "17","12","73"]
    var prices = ["50","50", "50","50", "50","50", "50","50", "50","50", "0","0","100"]
    var customizeImages = [UIImage(named: "espressoshot@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "whippedcream@2x.jpg"), UIImage(named: "chocolatechip@2x.jpg"), UIImage(named: "sources@2x .jpg"), UIImage(named: "sources@2x .jpg"), UIImage(named: "citrus@2x.jpg")]
    
    
    
    @IBOutlet var customizeTableView: UITableView!
    
    var choicedIndex:IndexPath!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // せるが潰れないように高さを設定する
        customizeTableView.rowHeight = 90

        customizeTableView.dataSource = self
        customizeTableView.delegate = self
        
        let nib = UINib(nibName: "CustomizeTableViewCell", bundle: Bundle.main)
        customizeTableView.register(nib, forCellReuseIdentifier: "CustomizeCell")
        
        // 複数選択可にする
        //  参照 ( https://qiita.com/Shotaro_Mori_/items/130d10ae4453b14f2368 )
        customizeTableView.allowsMultipleSelection = true
        
        
    }
    
    // セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customizes.count
    }
    // セルの表示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // idをつけたセルの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizeCell") as! CustomizeTableViewCell
        
        cell.customizeImageView.image = customizeImages[indexPath.row]
        cell.customizeNameLabel.text = customizes[indexPath.row]
        cell.customPriceLabel.text = prices[indexPath.row]
        cell.customCalorieLabel.text = calories[indexPath.row]
        
       
        return cell
        
    }
    // セルが選択されたときに呼ばれる
    // *delegateを移譲していないと選択などができないので気を付ける
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                   let cell = tableView.cellForRow(at:indexPath)
        // チェックマークをつける
        cell?.accessoryType = .checkmark
        let ud = UserDefaults.standard
        // データを入れる空の配列を定義 複数のデータを入れたいから配列で定義する
        var array = [String]()
        // 
        
        if let data = UserDefaults.standard.array(forKey: "choice") {
            array = data as! [String]
        } else {
            
        }
        
        let selectedCustomize = customizes[indexPath.row]
        print(selectedCustomize)
        // 配列に値を追加
        array.append(selectedCustomize)
        UserDefaults.standard.set(array, forKey: "choice")
  

                
    // セル選択解除後に呼ばれる
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
             print("deselect - \(indexPath)")
        let cell = tableView.cellForRow(at:indexPath)
        var array = [String]()
        
        var saveArray = [String]()
        
        if let data = UserDefaults.standard.array(forKey: "choice") {
            array = data as! [String]
            for i in array {
                // 選んだものと一致したら追加しない
                if i == customizes[indexPath.row] {
                    
                } else {
                    saveArray.append(i)
                }
            }
            
            UserDefaults.standard.set(saveArray, forKey: "choice")
        } else {
            
        }

        // チェックマークを外す
        cell?.accessoryType = .none
   
    }
    
    func loadData() {
        
    
            
            let query = NCMBQuery(className: "customize")

            query?.findObjectsInBackground({ (results, error) in
             
                if error != nil {
                    
                    print(error)


                } else {
                    print(results)

                    let toppings = results as! [NCMBObject]

                    for i in toppings {
                        print(i)

                        let selectedCustomize = i.object(forKey: "customize") as! String
                        // カスタマイズの全てのデータ
                        print(selectedCustomize)

                    }

                }
                
            })



        }

        
    // 次の画面に遷移
        func toPost() {
        performSegue(withIdentifier: "toPost", sender: nil)
        
    }

}
}
