//
//  MainViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//
import UIKit
import NCMB
import SVProgressHUD
import SwiftUI
import Kingfisher
import SwiftData
import Floaty
import SwiftData

class MainViewController: UIViewController , UITableViewDataSource,UITableViewDelegate,TimelineTableViewCellDelegate{
    
    //作ったNotePostモデルを取得する
    var selectedPost : NotePost?
    
    var posts = [NotePost]()
    var blockUserIdArray = [String]()
    var followings = [NCMBUser]()
    
    
    @IBOutlet var timelineTableView : UITableView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
        //カスタムビューの取得,xibの登録
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        timelineTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        //tableviewの下の線を消すだっけ？？
        timelineTableView.tableFooterView = UIView()
        
        //自動で高さを変更する
        timelineTableView.estimatedRowHeight = 597
        //timelineTableView.rowHeight <= self.view.bounds.height - 20
        timelineTableView.rowHeight = UITableView.automaticDimension
        //tabBarの背景色変更
        //UITabBar.appearance().barTintColor = #colorLiteral(red: 0.6, green: 0.8392156863, blue: 1, alpha: 1)
        //tabBarの文字色の設定
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.2196078431, green: 0.4078431373, blue: 0.8901960784, alpha: 1)
   
        // セパレーターの左側の余白を消す
        timelineTableView.separatorInset = UIEdgeInsets.zero
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //投稿したものがリアルタイムで更新されるようにする　→　画像の表示が毎回時間かかる
        self.loadTimeline()
    }
    
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択したpostsをselectedPostに代入
        selectedPost = posts[indexPath.row]
        //タップしたら次の画面に行くように、これは画面が遷移するだけで値は渡せてない
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        //セルの選択解除
        timelineTableView.deselectRow(at: indexPath,animated:true)
    }
    
    //画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //画面が移るときに値を渡す。""ないがsegueの名前
        if segue.identifier == "toDetail" {
            //次の画面があるのを教えて名前をつけて次の画面の型に変換する
            let detailViewController = segue.destination as! DetailNoteViewController
            //遷移した先のselectedPostにこっち側の投稿を一括で遷移させる
            detailViewController.selectedPost = selectedPost
        }
        
    }
    //セルに表示させる数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    //セルに表示させる内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = timelineTableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        let user = posts[indexPath.row].user
        
        cell.userNameLabel.text = user.userName
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user.objectId
        cell.userImageView.kf.setImage (with: URL (string: userImageUrl), placeholder: UIImage (named: "placeholder.jpg"))
        
        
        //投稿したコメントの設定
        cell.commentLabel.text = posts[indexPath.row].text
        //投稿した写真の設定
        let imageUrl = posts[indexPath.row].imageUrl
        cell.photoImageView.kf.setImage(with: URL(string: imageUrl))
        
        //画像サイズの拡大
        cell.likeButton.imageView?.contentMode = .scaleAspectFit
        cell.likeButton.contentHorizontalAlignment = .fill
        cell.likeButton.contentVerticalAlignment = .fill
        
        // Likeによってハートの表示を変える
        if posts[indexPath.row].isLiked == true {
            cell.likeButton.setImage(UIImage(systemName: "hands.sparkles.fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "hands.clap"), for: .normal)
        }
        
        // Likeの数
        //cell.likeCountLabel.text = "\(posts[indexPath.row].likeCount)件"
        
        // タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        dateFormatter.dateFormat = "yyyy/MM/dd HH"
        let dateString = dateFormatter.string(from: posts[indexPath.row].createDate)
        cell.timestampLabel.text = dateString + "時"
        
        return cell
    }
    
    
    
    //いいねボタンが押された時、どのセル、tableViewが押されたのか引数として引っ張ってくる
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        guard let currentUser = NCMBUser.current() else {
            //ログインに戻る
            let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            //画面の切り替えができる
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //次回起動時にログインしていない状態にする
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            return
            
        }
        
        if posts[tableViewCell.tag].isLiked == false || posts[tableViewCell.tag].isLiked == nil {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                //自分がlikeUserにあるかどうか
                //あったら、自分というオブジェクトが一個しかならないように保存する
                post?.addUniqueObject(currentUser.objectId, forKey: "likeUser")
                post?.saveEventually({ (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        self.loadTimeline()
                    }
                })
            })
        } else {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "likeUser")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadTimeline()
                        }
                    })
                }
            })
        }
    }
    
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
            SVProgressHUD.show()
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: self.posts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    // 取得した投稿オブジェクトを削除
                    post?.deleteInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            // 再読込
                            self.loadTimeline()
                            SVProgressHUD.dismiss()
                        }
                    })
                }
            })
        }
        let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
            let object = NCMBObject(className: "Report") //新たにクラス作る
            object?.setObject(self.posts[tableViewCell.tag].user.objectId, forKey: "reportUserId")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "エラーです")
                } else {
                    SVProgressHUD.showSuccess(withStatus: "この投稿を報告しました。ご協力ありがとうございました。")
                }
            })
        }
        let blockAction = UIAlertAction(title: "ブロックする", style: .default) { (action) in
            SVProgressHUD.show()
            let object = NCMBObject(className: "Block") //新たにクラス作る
            object?.setObject(self.posts[tableViewCell.tag].user.objectId, forKey: "blockUserId")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                } else {
                    SVProgressHUD.dismiss(withDelay: 2)
                    //ここで③を読み込んでいる
                    self.getBlockUser()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        if posts[tableViewCell.tag].user.objectId == NCMBUser.current().objectId {
            // 自分の投稿なので、削除ボタンを出す
            alertController.addAction(deleteAction)
        } else {
            // 他人の投稿なので、報告ボタンを出す
            alertController.addAction(reportAction)
            alertController.addAction(blockAction)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func loadTimeline(){
        guard let currentUser = NCMBUser.current() else {
            //ログインに戻る
            //ログアウト成功
            let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            //画面の切り替えができる
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            //次回起動時にログインしていない状態にする
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            return
        }
        
        
        let query = NCMBQuery(className: "Post")
        
        //Userの情報も取ってくる
        query?.includeKey("user")
        
        // 降順
        query?.order(byDescending: "createDate")
        
        //投稿した資格の名前と一致するものを持ってくる
        query?.whereKey("certification", equalTo: UserDefaults.standard.string(forKey:"certification")!)
        
        // フォロー中の人 + 自分の投稿だけ持ってくる
        //query?.whereKey("user", containedIn: followings)
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                SVProgressHUD.show()
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [NotePost]()
                
                for postObject in result as! [NCMBObject] {
                    
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        
                        userModel.displayName = user.object(forKey: "displayName") as? String
                        
                        
                        // 投稿の情報を取得
                        let imageUrl = postObject.object(forKey: "imageUrl") as! String
                        let text = postObject.object(forKey: "text") as! String
                        
                        //投稿したものがなんの資格かif let
                        
                        //let id = postObject.object(forKey: "id") as! String
                        
                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                        let post = NotePost(objectId: postObject.objectId ,user: userModel, imageUrl: imageUrl, text: text, createDate: postObject.createDate)
                        
                        
                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                        let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                        if likeUsers?.contains(currentUser.objectId) == true {
                            post.isLiked = true
                        } else {
                            post.isLiked = false
                        }
                        
                        // いいねの件数
                        if let likes = likeUsers {
                            post.likeCount = likes.count
                        }
                        //これでブロックした人が自分の投稿から消える
                        if self.blockUserIdArray.contains(post.user.objectId) == false {
                            self.posts.append(post)
                        }
                    }
                }
                SVProgressHUD.dismiss()
                // 投稿のデータが揃ったらTableViewをリロード
                self.timelineTableView.reloadData()
                
            }
        })
    }
    
    
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        timelineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        self.loadTimeline()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    //    func loadFollowingUsers() {
    //        // フォロー中の人だけ持ってくる
    //        let query = NCMBQuery(className: "Follow")
    //        query?.includeKey("user")
    //        query?.includeKey("following")
    //        query?.whereKey("user", equalTo: NCMBUser.current())
    //        query?.findObjectsInBackground({ (result, error) in
    //            if error != nil {
    //                SVProgressHUD.showError(withStatus: error!.localizedDescription)
    //            } else {
    //                self.followings = [NCMBUser]()
    //                for following in result as! [NCMBObject] {
    //                    self.followings.append(following.object(forKey: "following") as! NCMBUser)
    //                }
    //                //self.followings.append(NCMBUser.current())
    //
    //                self.loadTimeline()
    //            }
    //        })
    //    }
    
    func getBlockUser(){
        let query = NCMBQuery(className: "Block")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }else{
                //removeAll()で初期化をし、データの重複を防ぐ
                self.blockUserIdArray.removeAll()
                for blockObject in result as! [NCMBObject]{
                    self.blockUserIdArray.append(blockObject.object(forKey: "blockUserId") as! String)
                }
            }
        })
        self.loadTimeline()
    }
    
}

