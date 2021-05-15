//
//  UserPageViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//

import Foundation
import UIKit
import NCMB

class UserPageViewController: UIViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //画面が戻った時に画像が入っているようにするためにviewwillappearを使う！
    override func viewWillAppear(_ animated: Bool) {
        //取得するファイル名を変更してNCMBfile型で取得
        let file = NCMBFile.file(withName: NCMBUser.current().objectId ,  data: nil) as! NCMBFile
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
