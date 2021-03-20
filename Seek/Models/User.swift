//
//  User.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/11/11.
//

import UIKit

class User: NSObject {
    var objectId: String
    var userName: String

    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
}
