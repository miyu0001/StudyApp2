//
//  SignInViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//

import Foundation
import UIKit
import NCMB

class SignInViewController: UIViewController , UITextFieldDelegate {
    
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        //他のところをタッチしたらキーボードが閉じる
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
        //ボタン丸くする
        signInButton.layer.cornerRadius = 10.0
        
        //バーの色変更
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.barTintColor = #colorLiteral(red: 0.2196078431, green: 0.4078431373, blue: 0.8, alpha: 1)
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 0.2196078431, green: 0.4078431373, blue: 0.8, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //バーの色も同じにしてくれるけど全体が下に下がる
        self.navigationController?.navigationBar.isTranslucent = false
        //y座標の調整
        extendedLayoutIncludesOpaqueBars = true
    }
    
    //キーボード下げる関数
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    //入力後に入力用キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //閉じるコード
        textField.resignFirstResponder()
        //改行ボタンがつくようになる
        return true
    }
    
    
    //ログインボタンを押した時
    @IBAction func signIn(_ sender: Any) {
        //もしuseridとパスワードに1文字以上なんかが入力されていたら
        if (userIdTextField.text?.count)! > 0 && (passwordTextField.text?.count)! > 0 {
            
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text, password: passwordTextField.text) { (user, error) in
                //エラーがあった時
                if error != nil {
                    print(error)
                } else {
                    //自分の端末にログイン状態の保持
                    let ud = UserDefaults.standard
                    
                    //再度ログインしてももともと持ってたアカウントの資格に入れる
                    ud.set(user?.object(forKey: "certification"), forKey: "certification")
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                    
                    //ログイン成功したので画面遷移
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    
                    //storyboard間の画面遷移
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                }
            }
        }
    }
    @IBAction func forgetPassword(_ sender: Any) {
        //置いておく
        
    }
}
