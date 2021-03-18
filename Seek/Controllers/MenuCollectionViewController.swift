//
//  CollectionViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/15.
//

import UIKit
import NCMB

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet private var menuCollectionView: UICollectionView!
    var menuArrays = [Menu]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMenuData()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        let nib = UINib(nibName: "MenuCollectionViewCell", bundle: Bundle.main)
        menuCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 54
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuCollectionViewCell else { abort() }
        if menuArrays.count > 0 {
            cell.indexPath = indexPath
            cell.menuArrays = menuArrays
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: menuCollectionView.bounds.width/2.377, height: menuCollectionView.bounds.height/4.2)
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIndex = indexPath
        let selectedMenu = menuArrays[indexPath.row].menuName
        let ud = UserDefaults.standard
        UserDefaults.standard.setValue(selectedMenu, forKey: "selected")
        ud.synchronize()
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }

    func getMenuData() {
          let query = NCMBQuery(className: "menu")
              query?.findObjectsInBackground({ (results, error) in
                  if error != nil {
                 } else {
                  let menus = results as? [NCMBObject] ?? []
                    for menu in menus {
                        guard let menuName = menu.object(forKey: "menu") as? String else { return }
                        guard let menuImageUrl = menu.object(forKey: "image") as? String else { return }
                        let menuArray = Menu(menuName: menuName, menuImageUrl: menuImageUrl)
                        self.menuArrays.append(menuArray)
                    }
                 }
                self.menuCollectionView.reloadData()
              })
    }
}
