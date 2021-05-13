//
//  SignUpViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//

import Foundation
import UIKit
import NCMB

class SignUpViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
    }
    
    //入力後に入力用キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //閉じるコード
        textField.resignFirstResponder()
        //改行ボタンがつくようになる
        return true
    }
    
    @IBAction func signUp (_ sender: Any) {
        let user = NCMBUser()
        
        //userIdが4文字以下だったらこれ以下のコードは呼ばれない
        if (userIdTextField.text?.count)! <= 3 {
            print("文字数が足りません")
            return
        }
        
        //username = userIdになる
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        
        if passwordTextField.text == confirmTextField.text {
            user.password = passwordTextField.text!
        } else {
            print("パスワードが一致しません")
        }
        
        user.signUpInBackground { (error) in
            //エラーがあった場合
            if error != nil{
                print(error)
            } else {
                //登録成功したら画面が移るようにstoryboardを取得する
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                //画面の切り替えができる
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
                //ログイン状態の保持
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
            }
        }
    }
    
}


