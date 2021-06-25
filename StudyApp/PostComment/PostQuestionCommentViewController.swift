//
//  PostQuestionCommentViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/28.
//

import UIKit
import NYXImagesKit
import NCMB
import UITextView_Placeholder
import SVProgressHUD

class PostQuestionCommentViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    var postId : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        let user = NCMBUser.current()
        //他のところをタッチしたらキーボードが閉じる
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
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
    
    //他のところをタッチしたらキーボードが下がる
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func postComment(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let postObject = NCMBUser(className: "postComment")
        
        if self.commentTextView.text.count == 0 {
            print("入力されていません")
            return
        }
        
        postObject?.setObject(self.commentTextView.text, forKey: "text")
        postObject?.setObject(NCMBUser.current(), forKey: "user")
        postObject?.setObject(self.postId, forKey: "postId")
        postObject?.saveInBackground({ (error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                SVProgressHUD.dismiss()
                self.commentTextView.text = nil
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func cancelPostButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 55
    }

}
