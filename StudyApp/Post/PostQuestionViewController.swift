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
    
    
    
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.isEnabled = false
        //postTextView.placeholder = "キャプションを書く"
        postTextView.delegate = self
        
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        
        
        let user = NCMBUser.current()
        
        //NCMBUser.currentを取得してuserという変数に代入する。その時にnilじゃなかったら{}内でuserという定数が使える
        if let user = NCMBUser.current() {
            //それぞれ画像やテキストをNCMBのデータから引っ張って代入
            
            
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 55
    }
    
}

