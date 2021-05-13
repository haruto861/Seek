//
//  EditUserViewController.swift
//  originalApp
//
//  Created by 松島悠人 on 2020/10/10.
//

import UIKit
import NCMB
import NYXImagesKit

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
    }
    override func viewWillAppear(_ animated: Bool) {

        if let user  = NCMBUser.current() {
            userNameTextField.text = user.object(forKey: "displayName") as? String
            introductionTextView.text = user.object(forKey: "introduction") as? String
            userIdTextField.text = user.object(forKey: "userName") as? String

            guard let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: nil) as? NCMBFile else {
                return
            }
            file.getDataInBackground { [self] (data, error) in
                if error != nil {
                    print(error)
                } else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        self.userImageView.image = image
                    }
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let resizedImage = selectedImage?.scale(byFactor: 0.4)

        picker.dismiss(animated: true, completion: nil)
        let data  = resizedImage!.pngData()
        guard let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: data) as? NCMBFile else {
            return
        }
        file.saveInBackground { (error) in
            if error != nil {
            } else {
                self.userImageView.image = selectedImage
            }
        }
    }

    @IBAction func selectedImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択してください", preferredStyle: .actionSheet)
        actionController.popoverPresentationController?.sourceView=self.view
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action)
            in
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                
            } else {
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)

        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func closeEditViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveUserInfo() {
        let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey: "userName") as? String ?? ""
        user?.setObject(userIdTextField.text, forKey: "displayName") as? String ?? ""
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.saveInBackground({ (error) in
            if error != nil {
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
