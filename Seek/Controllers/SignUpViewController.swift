//
//  SignUpViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/09.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userTdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextFied: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        userTdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextFied.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func signUp() {
        let user = NCMBUser()
        if userTdTextField.text!.count <= 4 {
            print("文字数が足りません")
            return
        }
        user.userName = userTdTextField.text!
        user.mailAddress = emailTextField.text!
        if passwordTextField.text == confirmTextFied.text {
        user.password = passwordTextField.text!
        } else {
            print("error")
        }
        
        user.signUpInBackground { (error) in
            if error != nil {
                print("error")
                // エラーがあった場合
            } else {
                // 登録成功
                // 登録成功
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
               // ログイン状態の保持
                let ud = UserDefaults.standard
                ud.setValue(true, forKey: "isLogin")
                ud.synchronize()
            }
        }
}
}
