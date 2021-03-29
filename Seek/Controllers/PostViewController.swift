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
    @IBOutlet private weak var customizesTableView: UITableView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var totalCalorieLabel: UILabel!
    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var menuNameLabel: UILabel!
    private var selectedCustomizes = [String]()
    private var selectedMenu: String!
    private var customizeMenuNames =  [String]()
    private var customImageUrls = [String]()
    private var customizePrice = 0
    private var customizeCalorie = 0
    private var menuPrice = 0
    private var menuCalorie = 0
    private var totalCalorie = 0
    private var totalPrice = 0
    private var menuNames = [String]()
    private var menuImages = [String]()
    private var customizeArrays = [Customize]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getSeletedCustomizeData()
        customizesTableView.rowHeight = 70
        customizesTableView.delegate = self
        customizesTableView.dataSource = self
        selectedMenu = UserDefaults.standard.string(forKey: "selected")
        menuCalorie += UserDefaults.standard.integer(forKey: "menuCalorie")
        menuPrice += UserDefaults.standard.integer(forKey: "menuPrice")
        let nib = UINib(nibName: "PostTableViewCell", bundle: Bundle.main)
        customizesTableView.register(nib, forCellReuseIdentifier: "postCell")
        getSelectedMenuData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        if customizeArrays.isEmpty {
            return 0
        } else {
            print("numberOfRowsInSection完了")
            print(customizeArrays.count)
            return customizeArrays.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostTableViewCell else { abort()}
        if customizeArrays.count > 0 {
            cell.customizeArrays = customizeArrays
            cell.indexPath = indexPath
        }
        return cell
    }

    private func getSeletedCustomizeData() {
        let query = NCMBQuery(className: "customize")
        let seletedCustomizeData = UserDefaults.standard
        if seletedCustomizeData .array(forKey: "choice") == nil {
        } else {
            selectedCustomizes = seletedCustomizeData.array(forKey: "choice") as? [String] ?? []
            query?.whereKey("customize", containedIn: selectedCustomizes)
            query?.findObjectsInBackground({ (results, error) in
            guard let customizes = results as? [NCMBObject] else { return }
            for customize in customizes {
                guard let selectedCustomize = customize.object(forKey: "customize") as? String else { return }
                guard let selectedCustomizeImageUrl = customize.object(forKey: "image") as? String else { return }
                guard let selectedCustomizePrice = customize.object(forKey: "price") as? Int else { return  }
                guard let selectedCustomizeCalorie = customize.object(forKey: "calorie") as? Int else { return  }
                let customizeArray  = Customize(customizeName: selectedCustomize, customizeImageUrl: selectedCustomizeImageUrl, customizePrice: selectedCustomizePrice, customizeCalorie: selectedCustomizeCalorie)
                self.customizeArrays.append(customizeArray)
                self.customizePrice += selectedCustomizePrice
                self.customImageUrls.append(selectedCustomizeImageUrl)
                self.customizeMenuNames.append(selectedCustomize)
                
                self.customizeCalorie += selectedCustomizeCalorie
            }
                print("customizesTableView.reloadData()")
            self.customizesTableView.reloadData()
        })
        }
    }

    private func getSelectedMenuData() {
        KRProgressHUD.show()
        let query = NCMBQuery(className: "menu")
        query?.whereKey("menu", equalTo: selectedMenu)
        query?.findObjectsInBackground({ [self] (results, error) in
            guard let menus = results as? [NCMBObject] else { return }
            for menu in menus {
                guard let menuName = menu.object(forKey: "menu") as? String else { return }
                menuNames.append(menuName)
                self.menuNameLabel.text = menuName
                guard let menuImage = menu.object(forKey: "image") as? String else { return }
                menuImages.append(menuImage)
                self.menuImageView.kf.setImage(with:URL(string: menuImage))
            }
        })
        KRProgressHUD.dismiss()
    }

    override func viewDidAppear(_ animated: Bool) {
        totalPrice += menuPrice
        totalPrice += customizePrice
        totalPriceLabel.text = "\(totalPrice)"
        totalCalorie += menuCalorie
        totalCalorie += customizeCalorie
        totalCalorieLabel.text = "\(totalCalorie)"
    }

    private func presentAlert() {
        let alert  = UIAlertController(nibName: "接続エラー", bundle: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction private func sharePost() {
        KRProgressHUD.show()
        let postObject = NCMBObject(className: "post")
        let menuName = self.menuNames[0]
        let menuImage = self.menuImages[0]
        postObject?.setObject(menuName, forKey: "menuName")
        postObject?.setObject(menuImage, forKey: "menuImage")
        postObject?.setObject(totalPrice, forKey: "postPrice")
        postObject?.setObject(totalCalorie, forKey: "postCalorie")
        postObject?.setObject(customizeMenuNames, forKey: "toppings")
        postObject?.setObject(customImageUrls, forKey: "customImage")
        postObject?.setObject(NCMBUser.current(), forKey: "userName")
        postObject?.saveInBackground({ (error) in
            if error == nil {
                let index = self.navigationController!.viewControllers.count - 4
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[index], animated: true)
            } else {
                self.presentAlert()
            }

        })
        KRProgressHUD.dismiss()
    }
}
