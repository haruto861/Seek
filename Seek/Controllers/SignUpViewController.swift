//
//  SignUpViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/09.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private var userTdTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var confirmTextFied: UITextField!

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

    @IBAction private func signUp() {
        let user = NCMBUser()
        if userTdTextField.text!.count <= 4 {
            return
        }
        user.userName = userTdTextField.text!
        user.mailAddress = emailTextField.text!
        if passwordTextField.text == confirmTextFied.text {
        user.password = passwordTextField.text!
        } else {
        }
        user.signUpInBackground { (error) in
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
