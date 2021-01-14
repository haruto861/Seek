//
//  Post.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/11/10.
//

import UIKit
import NCMB

class Post: NSObject {
    
    
    var menuName: String!
    var menuImage: String!
    var totalPrice: String!
    var totalCalorie: String!
    var objectId: String
    var user: User!
    var createDate: Date!
    var toppings = [String]()
    var customImage = [String]()
    
    
    
    
    init(menuName: String, user: User, menuImage: String, totalPrice: String, totalCalorie: String, createDate: Date, toppings:[String], customImage:[String], objectId: String ) {
        // 取得した値を変数に代入
           self.menuName = menuName
           self.user = user
           self.menuImage = menuImage
           self.totalPrice = totalPrice
           self.totalCalorie = totalCalorie
           self.toppings = toppings
           self.objectId = objectId
           self.customImage = customImage
        
        
      
            
}

    
    

}
