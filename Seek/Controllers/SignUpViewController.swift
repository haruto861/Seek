//
//  SignUpViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/09.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController {
    @IBOutlet private var userTdTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var confirmTextFied: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        userTdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextFied.delegate = self
        registerButton.isEnabled = true
        registerButton.backgroundColor = .rgb(red: 34, green: 56, blue: 66)
    }

    @IBAction private func signUp() {
        let user = NCMBUser()
        user.userName = userTdTextField.text!
        user.mailAddress = emailTextField.text!
        if passwordTextField.text == confirmTextFied.text {
        user.password = passwordTextField.text!
        } else {
            self.presentAlert(title: "エラー", message: "パスワードが一致しておりません。")
        }
        user.signUpInBackground { (error) in
            if error == nil {
                self.presentAlert(title: "登録完了", message: "ご登録ありがとうございます。")
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                let ud = UserDefaults.standard
                ud.setValue(true, forKey: "isLogin")
                ud.synchronize()
            } else {
                self.presentAlert(title: "エラー", message: "アドレスの形式に誤りがあります")
            }
        }
    }

    private func presentAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
            }
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let userIdEmpty = userTdTextField.text?.isEmpty ?? false
        let passwordEmpty = passwordTextField.text?.isEmpty ?? false
        let emailEmpty = emailTextField.text?.isEmpty ?? false
        let confirmEmpty = confirmTextFied.text?.isEmpty ?? false
        
        if userIdEmpty || passwordEmpty || emailEmpty || confirmEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .rgb(red: 34, green: 56, blue: 66)
        }
    }
}
