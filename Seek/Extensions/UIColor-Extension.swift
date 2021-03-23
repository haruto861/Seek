//
//  UIColor-Extension.swift
//  Seek
//
//  Created by 松島悠人 on 2021/03/23.
//

import UIKit

extension UIColor {
    static func rgb(red:CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 250, green: green / 250, blue: blue / 250, alpha: 1)
    }
}
