//
//  EditUserViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/10.
//

import UIKit
import NCMB
import NYXImagesKit


// UIImageViewControllerの親クラスはUINavigationController
class EditUserViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userImageView: UIImageView!
    
    @IBOutlet var  userNameTextField: UITextField!
    
    @IBOutlet var  userIdTextField: UITextField!
    
    @IBOutlet var introductionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        userIdTextField.delegate = self
        introductionTextView.delegate = self
        
        let userId = NCMBUser.current()?.userName
        userIdTextField.text = userId
        
        
    
        
    }
    // キーボードを出すコード
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // キーボードを出すコード
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let resizedImage = selectedImage.scale(byFactor: 0.4)
        
        
        picker.dismiss(animated: true, completion: nil)
        
        let data  = resizedImage!.pngData()
        let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: data) as! NCMBFile
        file.saveInBackground { (error) in
            if error != nil {
                print(error)
            } else {
                self.userImageView.image = selectedImage
            }
        }
        
        
        
    }
    
    
    @IBAction func selectedImage() {

        // 画面下部から出てくるのはactionsheet
        let actionController = UIAlertController(title: "画像の選択", message: "選択してください", preferredStyle: .actionSheet)
        // iPadでは必須　(ipadではsourceviewを指定しないとクラッシュする）
        actionController.popoverPresentationController?.sourceView=self.view
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action)
            in
            // カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                
                
            } else {
                print("この機種ではカメラは使用できません")
            }
            
            
        }
        
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            // アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                
            } else {
                print("この機種ではフォトライブラリは使用できません")
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
            
            
        }
        
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        // アラートを表示させる
        self.present(actionController, animated: true, completion: nil)
        
        
    }
    
    // キャンセルボタンで前の画面に遷移
    
    @IBAction func closeEditViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveUserInfo() {
        let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey: "userName") as? String
        user?.setObject(userIdTextField.text, forKey: "displayName") as? String
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.saveInBackground({ (error) in
            if error != nil {
            } else {
                self.dismiss(animated: true, completion: nil)
                  
                
            }
                
            
        })

        
    }
    


}
