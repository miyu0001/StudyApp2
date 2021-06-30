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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var missLabel: UILabel!
    @IBOutlet weak var noUseNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        emailTextField.textContentType = UITextContentType.emailAddress
        passwordTextField.textContentType = UITextContentType.password
        
        //ナビゲーションコントローラーの色を変更
        self.navigationController?.navigationBar.barStyle = .black
        //バーの色を設定
        self.navigationController!.navigationBar.barTintColor = #colorLiteral(red: 0.2196078431, green: 0.4078431373, blue: 0.8, alpha: 1)
        //navigationbarの下のカラー
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        //navigationcontrollerの文字の色を白に設定（確か）
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //バーの色も同じにしてくれるけど全体が下に下がる
        self.navigationController?.navigationBar.isTranslucent = false
        //下に下がる分のy座標の調整
        extendedLayoutIncludesOpaqueBars = true
    
        
        //ボタンを丸くする
        signUpButton.layer.cornerRadius = 10.0
        
        //パスワードの文字が足りない時の注意ラベルは普通の時は隠しておく
        missLabel.isHidden = true
        noUseNameLabel.isHidden = true
        
        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
        //他のところをタッチしたらキーボードが閉じる
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    //他のところをタッチしたらキーボードが下がる
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
    
    @IBAction func signUp (_ sender: Any) {
        //NCMBから会員登録できるようにする　＝　userインスタンスの作成
        let user = NCMBUser()
        
        
        
        //userIdが4文字以下だったらこれ以下のコードは呼ばれない
        if (userIdTextField.text?.count)! <= 3 {
            //注意ラベルが表示されるようにする
            print("文字数が足りません")
            return
        }
        
        //パスワードの入力画面が7の字以下の時
        if (passwordTextField.text?.count)! <= 7 {
            //注意ラベルを出す
            missLabel.isHidden = false
            return
        }
        
        //NCMBにあるusernameをuserIdとして使う
        user.userName = userIdTextField.text!
        //メアドはそのまま使う
        user.mailAddress = emailTextField.text!
        
        //パスワード入力と再入力で一致した場合
        if passwordTextField.text == confirmTextField.text {
            
            user.password = passwordTextField.text!
        } else {
            // 一致しなかった場合　→　注意文の表示したい
            print("パスワードが一致しません")
            return
        }
        
        //新規登録を保存
        user.signUpInBackground { (error) in
            //エラーがあった場合
            if error != nil{
                //引数のエラーの値をprintする
                print(error)
                self.noUseNameLabel.isHidden = false
            } else {
                //エラーがなかったら資格ジャンル選択画面に遷移
                self.performSegue(withIdentifier: "toGenre", sender: nil)
            }
        }
    }
}


