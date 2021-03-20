//
//  CustomizeViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/19.
//

import UIKit
import NCMB

class CustomizeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var customizeArrays = [Customize]()
    @IBOutlet var customizeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getCustomizeData()
        customizeTableView.dataSource = self
        customizeTableView.delegate = self
        let nib = UINib(nibName: "CustomizeTableViewCell", bundle: Bundle.main)
        customizeTableView.register(nib, forCellReuseIdentifier: "CustomizeCell")
        customizeTableView.allowsMultipleSelection = true
    }

    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.array(forKey: "choice") == nil {
        } else {
            UserDefaults.standard.removeObject(forKey: "choice")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customizeArrays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizeCell") as? CustomizeTableViewCell else {
            abort()
        }
        if customizeArrays.count > 0 {
            cell.indexPath = indexPath
            cell.customizeArrays = customizeArrays
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ud = UserDefaults.standard
        var array = [String]()
        if let data = UserDefaults.standard.array(forKey: "choice") {
            array = data as? [String] ?? []
        } else {            
        }
        guard let selectedCustomize = customizeArrays[indexPath.row].customizeName else { return }
        array.append(selectedCustomize)
        UserDefaults.standard.set(array, forKey: "choice")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var array = [String]()
        var saveArray = [String]()
        if let data = UserDefaults.standard.array(forKey: "choice") {
            array = data as? [String] ?? []
            for text in array {
                if text == customizeArrays[indexPath.row].customizeName {
                } else {
                    saveArray.append(text)
                }
            }
            UserDefaults.standard.set(saveArray, forKey: "choice")
        } else {
        }
    }

    private func getCustomizeData() {
        let query = NCMBQuery(className: "customize")
        query?.findObjectsInBackground({ (results, error) in
            guard let customzies = results as? [NCMBObject] else { return }
            for customize in customzies {
                guard let customizeName = customize.object(forKey: "customize") as? String else { return }
                guard let customizeImageUrl = customize.object(forKey: "image") as? String else { return }
                guard let customizePrice = customize.object(forKey: "price") as? Int else { return }
                guard let customizeCalorie = customize.object(forKey: "calorie") as? Int else { return }
                let customizeArray = Customize(customizeName: customizeName, customizeImageUrl: customizeImageUrl, customizePrice: customizePrice, customizeCalorie: customizeCalorie)
                self.customizeArrays.append(customizeArray)
            }
            self.customizeTableView.reloadData()
        })
    }
}
