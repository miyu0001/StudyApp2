//
//  EditUserinfoViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/14.
//

import Foundation
import UIKit
import NCMB


class EditUserinfoViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var introductionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        userNameTextField.delegate = self
        introductionTextView.delegate = self
        
        //現在ログインしているユーザーを取得
        let userId = NCMBUser.current().userName
        userIdTextField.text = userId
    }

    //テキスト編集終了時に呼び出される
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    //フォトライブラリから画像が選ばれた時に呼ばれる関数
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //pickerからUIImage型として画像データを取り出す
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //画像を入れる
        userImageView.image = selectedImage
        //pickerした後はそのpickerを閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func selectImage(_ sender: Any) {
        //アクションシートを出すコード
        let actionController = UIAlertController(title: "画像の選択", message: "選択してください", preferredStyle: .actionSheet)
        //アラートとして表示させる
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラを起動
            //シュミレーターではカメラは使えないからボタンを押しても毎回クラッシュしないように
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                //カメラから引っ張ってくる
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではカメラは使えません")
            }
            
            
        }
        let albumAction = UIAlertAction(title: "画像を選択", style: .default) { (action) in
            //アルバム起動
            //フォトライブラリの時も一応使えない機種とで分けておく
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                //フォトライブラリから引っ張ってくる
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではフォトライブラリは使えません")
            }
            
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            //キャンセルボタンの作成
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        //アクションたちを自分の画面に表示させる
        self.present(actionController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func closeEditViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
