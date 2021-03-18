//
//  Customize.swift
//  Seek
//
//  Created by 松島悠人 on 2021/03/18.
//

import Foundation

class Customize: NSObject {
    let customizeName:String!
    let customizeImageUrl:String!
    let customizePrice:Int!
    let customizeCalorie:Int!
    
    init(customizeName: String, customizeImageUrl: String, customizePrice: Int, customizeCalorie: Int) {
        self.customizeName = customizeName
        self.customizeImageUrl = customizeImageUrl
        self.customizePrice = customizePrice
        self.customizeCalorie = customizeCalorie
    }
}
