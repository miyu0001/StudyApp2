//
//  PostQuestionViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/22.


import UIKit
import NYXImagesKit
import NCMB
import UITextView_Placeholder
import SVProgressHUD

class PostQuestionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    //let placeholderImage = UIImage(named: "photo-placeholder")
    
    var resizedImage: UIImage!
    
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        //　ナビゲーションバーの背景色
        navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // その他UIColor.white等好きな背景色
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = #colorLiteral(red: 0.2196078431, green: 0.4078431373, blue: 0.8901960784, alpha: 1)
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor : UIColor.black
        ]
        
        postButton.isEnabled = false
        //postTextView.placeholder = "キャプションを書く"
        postTextView.delegate = self
        
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        //NCMBUser.currentを取得してuserという変数に代入する。その時にnilじゃなかったら{}内でuserという定数が使える
        if let user = NCMBUser.current() {
           
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
                        self.userImage.image = image
                    }
                }
            }
        } else {
            //NCMBuser.currentがnilだった時ログイン画面にもどす=ログアウトさせる
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
    
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    
    func confirmContent() {
        if postTextView.text.count > 0  {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }
    
    
    @IBAction func sharePhoto() {
        SVProgressHUD.show()
        let postObject = NCMBObject(className: "QuestionPost")
        if self.postTextView.text.count == 0 {
            print("入力されていません")
            return
        }
        //今選択してる情報が何か
        let selectedCertification = UserDefaults.standard.string(forKey: "certification")
        postObject?.setObject(selectedCertification!, forKey: "certification")
        postObject?.setObject(self.postTextView.text!, forKey: "text")
        postObject?.setObject(NCMBUser.current(), forKey: "user")
        postObject?.saveInBackground({ (error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                SVProgressHUD.dismiss()
                self.postTextView.text = nil
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    @IBAction func cancel() {
        if postTextView.isFirstResponder == true {
            postTextView.resignFirstResponder()
        }
        
        let alert = UIAlertController(title: "投稿内容の破棄", message: "入力中の投稿内容を破棄しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.postTextView.text = nil
            //self.postImageView.image = UIImage(named: "photo-placeholder")
            self.confirmContent()
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

