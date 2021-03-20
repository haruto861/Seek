//
//  SignInViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/09.
//

import UIKit
import NCMB

class SignInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        userIdTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func signIn() {
        if userIdTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                } else {
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
}
