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
    // 通常ミルク
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // 低脂肪ミルク
    @IBOutlet weak var segmentedControl2: UISegmentedControl!
    // 無脂肪ミルク
    @IBOutlet weak var segmentedControl3: UISegmentedControl!
    // アーモンドミルク
    @IBOutlet weak var segmentedControl4: UISegmentedControl!
    // ソイミルク
    @IBOutlet weak var segmentedControl5: UISegmentedControl!
    // とりあえずラベル
    @IBOutlet weak var label1:UILabel!
    @IBOutlet weak var label2:UILabel!

    // ミルク変更スイッチ
    // 通常ミルク
    @IBOutlet weak var switch1: UISwitch!
    // 低脂肪ミルク
    @IBOutlet weak var switch2: UISwitch!
    // 無脂肪ミルク
    @IBOutlet weak var switch3: UISwitch!
    // アーモンドミルク
    @IBOutlet weak var switch4: UISwitch!
    // ソイミルク
    @IBOutlet weak var switch5: UISwitch!

    // ミルク選択の枠
    @IBOutlet weak var view2: UIView!
    // メニューの枠
    @IBOutlet var view3: UIView!
    // カロリー・価格
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet var passedMenuImage: UIImageView!
    // 画像データの受け皿
    var selectedImage: UIImage!
    @IBOutlet var passedMenuNameLabel: UILabel!
    @IBOutlet var passedCalorieLabel: UILabel!
    @IBOutlet var passedPriceLabel: UILabel!
    // DBからカロリー、価格を受け取る
    var passedCalorie = [Int]()
    var passedPrice = [Int]()
    //  データの受け皿を作成
    var passedData: NCMBObject!
    var passedMenu: String!
    // カロリー
    var menuCalorie = 0
    var menuPrice = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // ud領域を確保
        let ud = UserDefaults.standard
        // udのselecrtedキーの中身(コレクションビューで選択された物)を呼び出す
        passedMenu = ud.string(forKey: "selected")
        shadowView()
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
          query?.whereKey("menu", equalTo: passedMenu as? String ?? "")
              // 列のデータを取得
        query?.findObjectsInBackground({ [self] (results, error) in
                  if error != nil {
                      print(error)
                 } else {
                    // 取り出した結果(results)をNCMB型にダウンキャストして変数に代入
                    // データは一つしかないが、形式的には配列
                    let menus = results as? [NCMBObject] ?? []
                    // 配列の一つ目のデータを取り出す
                    let menu = menus[0]
                    print(menu)
                    self.passedPrice = menu.object(forKey: "price") as? [Int] ?? []
                    self.passedCalorie = menu.object(forKey: "calorie") as? [Int] ?? []
                    self.passedMenuNameLabel.text = menu.object(forKey: "menu") as? String ?? ""
                    let imageUrl = menu.object(forKey: "image") as? String ?? ""
                        print(imageUrl)
                         // urlを変換
                        self.passedMenuImage.kf.setImage(with:URL(string: imageUrl))
                        // 画像を読み込むための処理
                        KRProgressHUD.dismiss()
                  }
              })
    }

    @IBAction func didTappedButton(_ sender: Any) {
        // 通常ミルクが選択されたとき
        if switch1.isOn {
            // カロリー、値段
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                let short: Int =  passedCalorie[0]
                let short2: Int = passedPrice[0]
                label1.text = "\(short)"
                label2.text = "\(short2)"
                print(short)
            case 1:
                let tall: Int = passedCalorie[1]
                let tall2: Int = passedPrice[1]
                label1.text = "\(tall)"
                label2.text = "\(tall2)"
            case 2:
                let grande: Int = passedCalorie[2]
                let grande2: Int = passedPrice[2]
                label1.text = "\(grande)"
                label2.text = "\(grande2)"
            case 3:
                let venti = passedCalorie[3]
                let venti2 = passedPrice[3]
                label1.text = "\(venti)"
                label2.text = "\(venti2)"

            default:
                return
            }
            let menuCalorie = Int(label1.text ?? "") ?? 0
            let menuPrice = Int(label2.text ?? "") ?? 0
            let ud = UserDefaults.standard
            UserDefaults.standard.setValue(menuCalorie, forKey: "menuCalorie")
            UserDefaults.standard.setValue(menuPrice, forKey: "menuPrice")
            ud.synchronize()
        }
        // 低脂肪ミルク
        if switch2.isOn {
            // カロリー、値段
            switch segmentedControl2.selectedSegmentIndex {
            case 0:
                let short: Int =  passedCalorie[4]
                let short2: Int = passedPrice[0]
                label1.text = "\(short)"
                label2.text = "\(short2)"
                print(short)
            case 1:
                let tall: Int = passedCalorie[5]
                let tall2: Int = passedPrice[1]
                label1.text = "\(tall)"
                label2.text = "\(tall2)"
            case 2:
                let grande: Int = passedCalorie[6]
                let grande2: Int = passedPrice[2]
                label1.text = "\(grande)"
                label2.text = "\(grande2)"
            case 3:
                let venti = passedCalorie[7]
                let venti2 = passedPrice[3]
                label1.text = "\(venti)"
                label2.text = "\(venti2)"

            default:
                return
            }
            let menuCalorie = Int(label1.text ?? "") ?? 0
            let menuPrice = Int(label2.text ?? "") ?? 0
            let ud = UserDefaults.standard
            UserDefaults.standard.setValue(menuCalorie, forKey: "menuCalorie")
            UserDefaults.standard.setValue(menuPrice, forKey: "menuPrice")
            ud.synchronize()
        }
        // 無脂肪ミルク
        if switch3.isOn {
                // カロリー、値段
                switch segmentedControl3.selectedSegmentIndex {
                case 0:
                    let short: Int =  passedCalorie[8]
                    let short2: Int = passedPrice[0]
                    label1.text = "\(short)"
                    label2.text = "\(short2)"
                    print(short)
                case 1:
                    let tall: Int = passedCalorie[9]
                    let tall2: Int = passedPrice[1]
                    label1.text = "\(tall)"
                    label2.text = "\(tall2)"
                case 2:
                    let grande: Int = passedCalorie[10]
                    let grande2: Int = passedPrice[2]
                    label1.text = "\(grande)"
                    label2.text = "\(grande2)"
                case 3:
                    let venti = passedCalorie[11]
                    let venti2 = passedPrice[3]
                    label1.text = "\(venti)"
                    label2.text = "\(venti2)"

                default:
                    return
                }
            let menuCalorie = Int(label1.text ?? "") ?? 0
            let menuPrice = Int(label2.text ?? "") ?? 0
            let ud = UserDefaults.standard
            UserDefaults.standard.setValue(menuCalorie, forKey: "menuCalorie")
            UserDefaults.standard.setValue(menuPrice, forKey: "menuPrice")
            ud.synchronize()
            }
        if switch4.isOn {
            // アーモンドミルク
            switch segmentedControl4.selectedSegmentIndex {
            case 0:
                let short: Int =  passedCalorie[12]
                let short2: Int = passedPrice[4]
                label1.text = "\(short)"
                label2.text = "\(short2)"
            case 1:
                let tall: Int = passedCalorie[13]
                let tall2: Int = passedPrice[5]
                label1.text = "\(tall)"
                label2.text = "\(tall2)"
            case 2:
                let grande: Int = passedCalorie[14]
                let grande2: Int = passedPrice[6]
                label1.text = "\(grande)"
                label2.text = "\(grande2)"
            case 3:
                let venti = passedCalorie[15]
                let venti2 = passedPrice[7]
                label1.text = "\(venti)"
                label2.text = "\(venti2)"

            default:
                return
            }
            let menuCalorie = Int(label1.text ?? "") ?? 0
            let menuPrice = Int(label2.text ?? "") ?? 0
            let ud = UserDefaults.standard
            UserDefaults.standard.setValue(menuCalorie, forKey: "menuCalorie")
            UserDefaults.standard.setValue(menuPrice, forKey: "menuPrice")
            ud.synchronize()
        }
        if switch5.isOn {
            // ソイミルク
            switch segmentedControl5.selectedSegmentIndex {
            case 0:
                let short: Int =  passedCalorie[12]
                let short2: Int = passedPrice[4]
                label1.text = "\(short)"
                label2.text = "\(short2)"
                print(short)
            case 1:
                let tall: Int = passedCalorie[13]
                let tall2: Int = passedPrice[5]
                label1.text = "\(tall)"
                label2.text = "\(tall2)"
            case 2:
                let grande: Int = passedCalorie[14]
                let grande2: Int = passedPrice[6]
                label1.text = "\(grande)"
                label2.text = "\(grande2)"
            case 3:
                let venti = passedCalorie[15]
                let venti2 = passedPrice[7]
                label1.text = "\(venti)"
                label2.text = "\(venti2)"

            default:
                return
            }
            let menuCalorie = Int(label1.text ?? "") ?? 0
            let menuPrice = Int(label2.text ?? "") ?? 0
            let ud = UserDefaults.standard
            UserDefaults.standard.setValue(menuCalorie, forKey: "menuCalorie")
            UserDefaults.standard.setValue(menuPrice, forKey: "menuPrice")
            ud.synchronize()
        }
        if switch1.isOn == false && switch2.isOn == false && switch3.isOn == false && switch4.isOn == false && switch5.isOn == false  {
            label1.text = ""
            label2.text = ""
            self.alertPresent()
        }
    }
    private func shadowView() {
        view2.layer.shadowOpacity = 0.5 // 影の濃さを指定
        view2.layer.shadowOffset = CGSize(width: 3.0, height: 3.0) // 距離を指定
        view2.layer.cornerRadius = 15.0
        view3.layer.shadowOpacity = 0.5 // 影の濃さを指定
        view3.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        view3.layer.cornerRadius = 15.0

        view4.layer.shadowOpacity = 0.5 // 影の濃さを指定
        view4.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        view4.layer.cornerRadius = 15.0

        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        button.layer.cornerRadius = 8.0
        
    }
    private func alertPresent() {
        let alert = UIAlertController(title: "エラー", message: "ミルク・サイズを選択してください。\nミルク不使用の場合は”MIlK”でサイズを選んでください。", preferredStyle: .alert)
        // 特に行う動作はないのでhandlerはnil
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    private func saveData() {
        let ud = UserDefaults.standard
        UserDefaults.standard.setValue(menuCalorie, forKey: "menuCalorie")
        UserDefaults.standard.setValue(menuPrice, forKey: "menuPrice")
        ud.synchronize()
    }
        }


    

