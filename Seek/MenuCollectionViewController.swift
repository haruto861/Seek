//
//  CollectionViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/15.
//

import UIKit
import NCMB

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var menuCollectionView: UICollectionView!
    var selectedIndex: IndexPath!
    var drinks = [NCMBObject]()
    var selectedMenu: String!


    var menuArrays = [Menu]()

    var menuName = ["ドリップコーヒー", "カフェミスト","コールドブリューコーヒー", "スターバックスラテ","スターバックスラテ(アイス)","カプチーノ","カフェ モカ", "カフェ モカ(アイス)","ホワイト モカ","ホワイト モカ(アイス)", "キャラメル マキアート","キャラメル マキアート(アイス)",  "カフェ　アメリカーノ","カフェ　アメリカーノ(アイス)", "エスプレッソ","エスプレッソ コンパナ", "エスプレッソ マキアート","ムース フォーム ラテ", "アイス ムース フォーム ラテ", "ムース フォーム キャラメル マキアート","アーモンド ミルクラテ", "マンゴー パッション ティー フラペチーノ®︎", "コーヒー フラペチーノ®︎","キャラメル フラペチーノ®︎", "ダーク モカ チップ フラペチーノ®︎", "ダーク モカ チップ クリーム フラペチーノ®︎","抹茶 クリーム フラペチーノ®︎", "バニラ クリーム フラペチーノ®︎","エスプレッソ アフォガート フラペチーノ®", "アイスティー(パッション)", "アイスティー(ブラック)","抹茶 ティー ラテ", "チャイ ティー ラテ", "チャイ ティー ラテ（アイス）",  "イングリッシュ ブレックファスト ティー ラテ","アール グレイ ティー ラテ", "ほうじ茶 ティー ラテ", "ゆず シトラス ＆ ティー（ホット）","ゆず シトラス ＆ ティー（アイス）","ミント シトラス ティー ラテ","ユースベリー®", "ミント シトラス","イングリッシュ ブレックファスト", "アール グレイ", "カモミール","ハイビスカス", "ほうじ茶","ココア", "アイスココア", "キャラメルスチーマー","キャラメルスチーマー(アイス)","ホワイトホットチョコレート", "ホワイトホットチョコレート(アイス)"]
    let menuImage = [UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "CBR@2x.JPG"), UIImage(named: "Hot@2x.JPG"),UIImage(named: "L@2x.JPG"),  UIImage(named: "Hot@2x.JPG"),UIImage(named: "Hot@2x.JPG"),UIImage(named: "CO@2x.JPG"), UIImage(named: "Hot@2x.JPG"),UIImage(named: "L@2x.JPG"),UIImage(named: "Hot@2x.JPG"), UIImage(named: "CM@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "CBR@2x.JPG"),UIImage(named: "Hot@2x.JPG"),UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "ML@2x.JPG"), UIImage(named: "ML@2x.JPG"),UIImage(named: "Hot@2x.JPG"),UIImage(named: "MJ@2x.JPG"), UIImage(named: "CF@2x.JPG"), UIImage(named: "CRF@2x.JPG"), UIImage(named: "DF@2x.JPG"), UIImage(named: "DF@2x.JPG"),UIImage(named: "GF@2x.JPG"), UIImage(named: "VF@2x.JPG"), UIImage(named: "EAF@2x.JPG"), UIImage(named: "Tea-P@2x.JPG"), UIImage(named: "Tea-B@2x.JPG"),UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "L@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"),UIImage(named: "Hot@2x.JPG"),UIImage(named: "Hot@2x.JPG"), UIImage(named: "YC@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"),UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"), UIImage(named: "Hot@2x.JPG"),UIImage(named: "Hot@2x.JPG"), UIImage(named: "CO@2x.JPG"),UIImage(named: "Hot@2x.JPG"),UIImage(named: "VF@2x.JPG"),UIImage(named: "Hot@2x.JPG"), UIImage(named: "WCO@2x.JPG")]
    
        override func viewDidLoad() {
        super.viewDidLoad()
        getMenuData()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        // nibの登録
        let nib = UINib(nibName: "MenuCollectionViewCell", bundle: Bundle.main)
        menuCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")

    }
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuName.count
    }
    // 内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuCollectionViewCell else {
            abort()
        }
        cell.menuNameLabel.text = menuName[indexPath.row]
        cell.menuImageView.image = menuImage[indexPath.row]
        return cell
    }
    // 一列に表示させるセルの個数をデバイスごとによって可変させる
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: menuCollectionView.bounds.width/2.377, height: menuCollectionView.bounds.height/4.2)
    }
    // セル選択時に呼ばれる関数

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let selectedMenu = menuName[indexPath.row]
        // 画面間の値渡し（userdefalults)
        // 選択されたメニューをuserdefaultsに保存して端末内に値を保持
        let ud = UserDefaults.standard
        UserDefaults.standard.setValue(selectedMenu, forKey: "selected")
        ud.synchronize()
        print(selectedMenu)
        // 次の画面に遷移するsegueを呼び出す
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    // segue準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // seguのIDを確認して、特定のsegueの時のみ表示させる
        if segue.identifier == "toDetail" {
            // 遷移先のviewcontrollerを取得
            guard let detailViewController = segue.destination as? DetailViewController else {
                return
            }
            // 遷移先で用意した変数に値を渡す(選択した行のデータ)
            detailViewController.passedData = drinks[selectedIndex.row]
        }
    }
    
    func getMenuData() {
        // menuクラスを検索するNCMBQueryを作成
          let query = NCMBQuery(className: "menu")
              query?.findObjectsInBackground({ (results, error) in
                  if error != nil {
                 } else {
                  let menus = results as? [NCMBObject] ?? []
                    // 一個づつデータを取り出す
                    for menu in menus {
                        guard let menuName = menu.object(forKey: "menu") as? String else { return }
                        guard let menuImageUrl = menu.object(forKey: "image") as? String else { return }
                        guard let menuPrice = menu.object(forKey: "price") as? Int else { return }
                        guard let menuCalorie = menu.object(forKey: "calorie") as? Int else { return }
                        let menuArray = Menu(menuName: menuName, menuImageUrl: menuImageUrl, menuCalorie: menuCalorie, menuPrice: menuPrice)
                        self.menuArrays.append(menuArray)
                        self.menuCollectionView.reloadData()
                    }
                  }
              })
    }
}
