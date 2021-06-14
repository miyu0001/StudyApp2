//
//  EditUserinfoViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/14.
//

import Foundation
import UIKit
import NCMB
import NYXImagesKit
import CropViewController


class EditUserinfoViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,CropViewControllerDelegate{
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var changeCertification: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //他のところをタップしたらキーボードが下がる
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
        //画像を資格から丸にする
        userImageView.layer.cornerRadius =  userImageView.bounds.width / 2
        userImageView.layer.masksToBounds = true
        
        userNameTextField.delegate = self
        userIdTextField.delegate = self
        
        changeCertification.setTitle(UserDefaults.standard.string(forKey: "certification"), for: .normal)
        
        //それぞれ画像やテキストをNCMBのデータから引っ張って代入
        if let user = NCMBUser.current() {
            //NCMBuser.current()がnilじゃなかったらこっちの処理
            userNameTextField.text = user.object(forKey: "displayName") as? String
            userIdTextField.text = user.userName
            introductionTextView.text = user.object(forKey: "introduction") as? String
            
            
            //現在ログインしているユーザーを取得
            let userId = NCMBUser.current().userName
            userIdTextField.text = userId
            
            //取得するファイル名を変更してNCMBfile型で取得
            let file = NCMBFile.file(withName: user.objectId ,  data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    print(error)
                } else {
                    //画像の取得に成功したら
                    //ますはデータをそのまま渡す
                    if data != nil {
                        let image = UIImage(data: data!)
                        self.userImageView.image = image
                    }
                }
            }
        } else {
            //NCMBuser.current()がnilだったらこっちの処理
            //ログイン画面にもどす
            //ログアウト成功
            let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            //画面の切り替えができる
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //次回起動時にログインしていない状態にする
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
 
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        //縦横比を維持しながらリサイズしてくれる
        let resizedImage = selectedImage.scale(byFactor: 0.3)
        
        //pickerした後はそのpickerを閉じる
        picker.dismiss(animated: true, completion: nil)
        
        //アップロードするにはUIImage型からデータ型に変えないといけない
        let data = resizedImage?.pngData()
        //選んだ画像を自分の情報と紐付けるNCMBfeleという型に変換する
        let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: data) as! NCMBFile
        file.saveInBackground { (error) in
            if error != nil {
                //エラーがあったら
                print(error)
            } else {
                //拾ってきた画像をimageViewに入れる
                self.userImageView.image = selectedImage
            }
        } progressBlock: { (progress) in // ← ？？
            print(progress)
        }
        
    }
    
    @IBAction func selectImage(_ sender: Any) {
        //アクションシートを出すコード
        let alertController = UIAlertController(title: "画像の選択", message: "選択してください", preferredStyle: .actionSheet)
        //アラートとして表示させる
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラを起動
            //シュミレーターではカメラは使えないからボタンを押しても毎回クラッシュしないように
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                //カメラから引っ張ってくる
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
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
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)

            } else {
                print("この機種ではフォトライブラリは使えません")
            }
            
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        //アクションたちを自分の画面に表示させる
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChange" {
            let NC = segue.destination as! UINavigationController
            
            //次の画面があるのを教える
            let changeGenreViewController = NC.topViewController as! changeGenreViewController
            //選択した投稿が一括で遷移させる
            changeGenreViewController.parentVC = self
         
            
        }
    }
    
    
    @IBAction func closeEditViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveUserInfo() {
        //今使ってるuserdefaultsを取り出す
        UserDefaults.standard.set(changeCertification.currentTitle, forKey: "certification")
        
        let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey: "displayName")
        user?.setObject(userIdTextField.text, forKey: "userName")
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.setObject(changeCertification.currentTitle, forKey: "certification")
        
        user?.saveInBackground{ (error) in
            if error != nil {
                print(error)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }

}
