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

    init(menuName: String, menuImageUrl: String) {
        self.menuName = menuName
        self.menuImageUrl = menuImageUrl
    }
}
