//
//  ResetPasswardViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/06/04.
//

import UIKit
import NCMB
import SVProgressHUD

class ResetPasswardViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var passwardTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
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

        resetButton.layer.cornerRadius = 10
        passwardTextField.delegate = self
        
        //他のところをタッチしたらキーボードが閉じる
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    //他のところをタッチしたらキーボードが下がる
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func resetPassward(_ sender: Any) {
        let result = NCMBUser.requestPasswordResetForEmail(inBackground: passwardTextField.text) { (error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }else{
                SVProgressHUD.showSuccess(withStatus: "パスワード再設定メールを送信しました。")
            }
        }
    }
}
