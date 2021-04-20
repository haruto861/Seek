//
//  getData.swift
//  Seek
//
//  Created by 松島悠人 on 2021/04/12.
//

import Foundation
import NCMB

class getData{

    var willPostDatas = [NCMBObject]()

    init(willPostDatas: [NCMBObject]) {
        self.willPostDatas = willPostDatas
    }

    func getData(){
        let query = NCMBQuery(className: "post")
        query?.order(byDescending: "createDate")
        query?.includeKey("userName")
        query?.findObjectsInBackground({ (results, error) in
            guard self.willPostDatas == results as? [NCMBObject]  else { return }
            for postData in self.willPostDatas {
                guard let user  = postData.object(forKey: "userName") as? NCMBUser else { return }
                guard let menuName = postData.object(forKey: "menuName") as? String else { return }
                guard let menuImageUrl = postData.object(forKey: "menuImage") as? String else { return }
                guard let prePostCalorie = postData.object(forKey: "postCalorie") as? Int else { return }
                guard let prePostPrice = postData.object(forKey: "postPrice") as? Int else { return }
                user.userName = user.object(forKey: "userName") as? String
                let userModel = User(objectId: user.objectId, userName: user.userName)
                let postPrice = "\(prePostPrice)"
                let postCalorie = "\(prePostCalorie)"
                let customImageUrls = postData.object(forKey: "customImage") as? [String] ?? []
                let customizes = postData.object(forKey: "toppings") as? [String] ?? []
                let objectId = postData.object(forKey: "objectId") as? String
                let post = Post(menuName: menuName, user: userModel, menuImage: menuImageUrl, totalPrice: postPrice, totalCalorie: postCalorie, createDate: postData.createDate, toppings: customizes, customImage: customImageUrls, objectId: objectId ?? "")
            }
        })
    }
}

