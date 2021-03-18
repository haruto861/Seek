//
//  Menu.swift
//  Seek
//
//  Created by 松島悠人 on 2021/03/18.
//

import Foundation

class Menu: NSObject {

    var menuName: String!
    var menuImageUrl: String!
    var menuCalorie: Int!
    var menuPrice: Int!

    init(menuName: String, menuImageUrl: String, menuCalorie: Int, menuPrice: Int) {
        self.menuName = menuName
        self.menuImageUrl = menuImageUrl
        self.menuCalorie = menuCalorie
        self.menuPrice = menuPrice
        
    }
    
}
