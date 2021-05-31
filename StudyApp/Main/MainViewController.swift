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

class MainViewController: UIViewController , UITableViewDataSource,UITableViewDelegate,TimelineTableViewCellDelegate{
    
    var selectedPost : NotePost?
    
    var posts = [NotePost]()
    
    var followings = [NCMBUser]()
 
    
    @IBOutlet var timelineTableView : UITableView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
        loadFollowingUsers()
        
        setRefreshControl()
        
        //カスタムビューの取得
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        timelineTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        timelineTableView.tableFooterView = UIView()
        
        timelineTableView.rowHeight = 360
        
    }
    
    override func viewWillAppear(_ animated: Bool) {        self.loadTimeline()
    }
    
    
    //移るだけ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPost = posts[indexPath.row]

        //タップしたら次の画面に行くように
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        
        
    }
    
    //画面が移るときに値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toDetail" {
            //次の画面があるのを教える
            let detailViewController = segue.destination as! DetailNoteViewController
            //選択した投稿が一括で遷移させる
            detailViewController.selectedPost = selectedPost
            
            print(selectedPost)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = timelineTableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        
        //内容
        cell.delegate = self
        cell.tag = indexPath.row
        
        let user = posts[indexPath.row].user
        print(user.userName)
        cell.userNameLabel.text = user.userName
        
        //userImageViewをkfでURLから画像に変換させる
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user.objectId as! String
        print(userImageUrl)
        
        cell.userImageView.kf.setImage(with: URL(string: userImageUrl),options: [.forceRefresh])
        
        
        cell.commentTextView.text = posts[indexPath.row].text
        let imageUrl = posts[indexPath.row].imageUrl as! String
        
        print(imageUrl)
        cell.photoImageView.kf.setImage(with: URL(string: imageUrl))
        
        
        // Likeによってハートの表示を変える
        if posts[indexPath.row].isLiked == true {
            cell.likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "heart-outline"), for: .normal)
        }
        
        // Likeの数
        //cell.likeCountLabel.text = "\(posts[indexPath.row].likeCount)件"
        
        // タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
        //cell.timestampLabel.text = posts[indexPath.row].createDate.toString()
        
        
        
        return cell
    }

    

    //いいねボタンが押された時、どのセル、tableViewが押されたのか引数として引っ張ってくる
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        let currentUser = NCMBUser.current()
        
        if posts[tableViewCell.tag].isLiked == false || posts[tableViewCell.tag].isLiked == nil {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                post?.addUniqueObject(currentUser?.objectId, forKey: "likeUser")
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
            SVProgressHUD.showSuccess(withStatus: "この投稿を報告しました。ご協力ありがとうございました。")
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
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton){
        
        // 選ばれた投稿を一時的に格納
        selectedPost = posts[tableViewCell.tag]
        
        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toComments", sender: nil)
        
    }
    
    
    
    
    func loadTimeline (){
        
        let currentUser = NCMBUser.current() 
        
        let query = NCMBQuery(className: "Post")
        
        //Userの情報も取ってくる
        query?.includeKey("user")
        
        // 降順
        query?.order(byDescending: "createDate")
        
        //投稿した資格の名前と一致するものを持ってくる
        query?.whereKey("certification", equalTo: UserDefaults.standard.string(forKey:"certification")!)
        
        print(currentUser)
        
        
        // フォロー中の人 + 自分の投稿だけ持ってくる
        //query?.whereKey("user", containedIn: followings)
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [NotePost]()
                
                for postObject in result as! [NCMBObject] {
                    print(result)
                    print(postObject)
             
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        
                        // 投稿したユーザーの情報をUserモデルにまとめる
                        
                        print(user.userName)
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        userModel.displayName = user.object(forKey: "displayName") as? String
                        
                        // 投稿の情報を取得
                        let imageUrl = postObject.object(forKey: "imageUrl") as! String
                        let text = postObject.object(forKey: "text") as! String
                        
                        //投稿したものがなんの資格か
                        //let id = postObject.object(forKey: "id") as! String
                        
                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                        let post = NotePost(objectId: postObject.objectId ,user: userModel, imageUrl: imageUrl, text: text, createDate: postObject.createDate)
                        
                        
                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                        let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                        if likeUsers?.contains(currentUser!.objectId) == true {
                            post.isLiked = true
                        } else {
                            post.isLiked = false
                        }
                        
                        // いいねの件数
                        if let likes = likeUsers {
                            post.likeCount = likes.count
                        }
                        
                        // 配列に加える
                        self.posts.append(post)
                    }
                }
                
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
        self.loadFollowingUsers()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    func loadFollowingUsers() {
        // フォロー中の人だけ持ってくる
        let query = NCMBQuery(className: "Follow")
        query?.includeKey("user")
        query?.includeKey("following")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.followings = [NCMBUser]()
                for following in result as! [NCMBObject] {
                    self.followings.append(following.object(forKey: "following") as! NCMBUser)
                }
                //self.followings.append(NCMBUser.current())
                
                self.loadTimeline()
            }
        })
    }
    
}


