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
    @IBOutlet private var totalPriceLabel: UILabel!
    @IBOutlet private var totalCalorieLabel: UILabel!
    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var menuNameLabel: UILabel!
    var selectedCustomizes = [String]()
    var selectedMenu: String!
    var customizeMenuNames =  [String]()
    var customImageUrls = [String]()
    var customizePrice = 0
    var customizeCalorie = 0
    var menuPrice = 0
    var menuCalorie = 0
    var totalCalorie = 0
    var totalPrice = 0
    var menuNames = [String]()
    var menuImages = [String]()

    var customizeArrays = [Customize]()

    override func viewDidLoad() {
        super.viewDidLoad()
        customizesTableView.rowHeight = 70
        customizesTableView.delegate = self
        customizesTableView.dataSource = self

        let ud = UserDefaults.standard
        if ud.array(forKey: "choice") == nil {
        } else {
            selectedCustomizes = ud.array(forKey: "choice") as? [String] ?? []
            print(selectedCustomizes)
        }
        selectedMenu = ud.string(forKey: "selected")
        menuCalorie += ud.integer(forKey: "menuCalorie")
        menuPrice += ud.integer(forKey: "menuPrice")
        getSelectedMenuData()
        getSeletedCustomizeData()

        let nib = UINib(nibName: "PostTableViewCell", bundle: Bundle.main)
        customizesTableView.register(nib, forCellReuseIdentifier: "postCell")
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return customizeArrays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostTableViewCell else { abort()}
        print(customizeArrays)
        if customizeArrays.count > 0 {
        }
        return cell
    }


    private func getSeletedCustomizeData() {
        let query = NCMBQuery(className: "customize")
        print(selectedCustomizes) // userdefaultsより先に呼ばれるとデータが空になる
        query?.whereKey("customize", containedIn: selectedCustomizes)
        query?.findObjectsInBackground({ (results, error) in
            print(results)
            guard let customizes = results as? [NCMBObject] else { return }
            for customize in customizes {
                guard let selectedCustomize = customize.object(forKey: "customize") as? String else { return }
                print(selectedCustomize)
                guard let selectedCustomizeImageUrl = customize.object(forKey: "image") as? String else { return }
                print(selectedCustomizeImageUrl)
                guard let selectedCustomizePrice = customize.object(forKey: "price") as? Int else { return  }
                print(selectedCustomizePrice)
                guard let selectedCustomizeCalorie = customize.object(forKey: "calorie") as? Int else { return  }
                print(selectedCustomizeCalorie)
                let customizeArray  = Customize(customizeName: selectedCustomize, customizeImageUrl: selectedCustomizeImageUrl, customizePrice: selectedCustomizePrice, customizeCalorie: selectedCustomizeCalorie)
                print(customizeArray)
                self.customizeArrays.append(customizeArray)
                print(self.customizeArrays)
                self.customizePrice += selectedCustomizePrice
                self.customizeCalorie += selectedCustomizeCalorie
//                self.customizeMenuNames.append(selectedCustomize)
//                self.customImageUrls.append(selectedCustomizeImageUrl)
            }
        })
        self.customizesTableView.reloadData()
    }

    private func getSelectedMenuData() {
        KRProgressHUD.show()
        let query = NCMBQuery(className: "menu")
        query?.whereKey("menu", equalTo: selectedMenu)
        query?.findObjectsInBackground({ [self] (results, error) in
            guard let menus = results as? [NCMBObject] else { return }
            for menu in menus {
                guard let menuName = menu.object(forKey: "menu") as? String else { return }
                self.menuNameLabel.text = menuName
                guard let menuImage = menu.object(forKey: "image") as? String else { return }
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
            }
        })
        KRProgressHUD.dismiss()
    }
}
