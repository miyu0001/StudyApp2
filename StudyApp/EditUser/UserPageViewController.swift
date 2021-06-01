//
//  UserPageViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//

import Foundation
import UIKit
import NCMB

class UserPageViewController: UIViewController{
    
    var posts = [NotePost]()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userIntroductionTextView: UITextView!
    @IBOutlet weak var userPageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画像を資格から丸にする
        userImageView.layer.cornerRadius =  userImageView.bounds.width / 2
        userImageView.layer.masksToBounds = true
    }
    
    //画面が戻った時に画像が入っているようにするためにviewwillappearを使う！
    override func viewWillAppear(_ animated: Bool) {
        
        //それぞれのユーザーの情報を取得する
        let user = NCMBUser.current()
        
        //NCMBUser.currentを取得してuserという変数に代入する。その時にnilじゃなかったら{}内でuserという定数が使える
        if let user = NCMBUser.current() {
            //それぞれ画像やテキストをNCMBのデータから引っ張って代入
            userDisplayNameLabel.text = user.object(forKey: "displayName") as? String
            userIntroductionTextView.text = user.object(forKey: "introduction") as? String
            self.navigationItem.title = user.object(forKey: "userName") as? String
            
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
    
    
    
    @IBAction func showMenu(_ sender: Any) {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください。", preferredStyle: .actionSheet)
        //アラートとしてログアウトボタンの表示
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    print(error)
                } else {
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
        }
        
        //アラートとして退会ボタンを表示させる
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    //退会成功
                    let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    //画面の切り替えができる
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //次回起動時にログインしていない状態にする
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        
        //アラートとしてキャンセルボタンの表示
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(signOutAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
