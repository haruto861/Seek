//
//  SignInViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/09.
//

import UIKit
import NCMB

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private var userIdTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

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

    @IBAction private func signIn() {
        if userIdTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                } else {
                    let storyboard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    let ud = UserDefaults.standard
                    ud.setValue(true, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        }
    }
}
