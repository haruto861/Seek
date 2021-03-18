//
//  CustomizeViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/19.
//

import UIKit
import NCMB

class CustomizeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    // カスタムメニューを入れる変数
    var customizes = ["エスプレッソショット","バニラシロップ", "キャラメルシロップ","クラシックシロップ", "アーモンドトフィーシロップ","チョコレートシロップ", "ホワイトモカシロップ","チャイシロップ", "ホイップクリーム","チョコレートチップ", "キャラメルソース","チョコレートソース","シトラス果肉","カスタマイズなし"]
    var calories = ["5","19", "19","21", "22","48", "53","34", "89","54", "17","12","73","0"]
    var prices = ["50","50", "50","50", "50","50", "50","50", "50","50", "0","0","100","0"]
    var customizeImages = [UIImage(named: "espressoshot@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "syrup@2x.jpg"), UIImage(named: "whippedcream@2x.jpg"), UIImage(named: "chocolatechip@2x.jpg"), UIImage(named: "sources@2x.jpg"), UIImage(named: "sources@2x.jpg"), UIImage(named: "citrus@2x.jpg"),UIImage(named: "sources@2x.jpg")]
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
        customizeTableView.allowsMultipleSelection = true
    }
    // セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customizes.count
    }
    // セルの表示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizeCell") as? CustomizeTableViewCell else {
            abort()
        }
        cell.customizeImageView.image = customizeImages[indexPath.row]
        cell.customizeNameLabel.text = customizes[indexPath.row]
        cell.customPriceLabel.text = prices[indexPath.row]
        cell.customCalorieLabel.text = calories[indexPath.row]
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        let ud = UserDefaults.standard
        // データを入れる空の配列を定義 複数のデータを入れたいから配列で定義する
        var array = [String]()
        if let data = UserDefaults.standard.array(forKey: "choice") {
            array = data as? [String] ?? []
        } else {            
        }
        let selectedCustomize = customizes[indexPath.row]
        print(selectedCustomize)
        // 配列に値を追加
        array.append(selectedCustomize)
        UserDefaults.standard.set(array, forKey: "choice")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
        var array = [String]()
        var saveArray = [String]()
        if let data = UserDefaults.standard.array(forKey: "choice") {
            array = data as? [String] ?? []
            for text in array {
                // 選んだものと一致したら追加しない
                if text == customizes[indexPath.row] {
                } else {
                    saveArray.append(text)
                }
            }
            UserDefaults.standard.set(saveArray, forKey: "choice")
        } else {
        }
    }

        func toPost() {
        performSegue(withIdentifier: "toPost", sender: nil)
    }
}
