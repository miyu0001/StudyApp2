//
//  MainViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//

import Foundation
import UIKit
import NCMB
import Kingfisher
import SVProgressHUD



class MainViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,TimelineTableViewCellDelegate{
    
    var posts = [Post]()
    @IBOutlet var timelineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        timelineTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        //TavleViewの不要な線を消す
        timelineTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        //内容
        //cell.delegate = self
        cell.tag = indexPath.row
        
        let user = posts[indexPath.row].user
        //userの名前を表示
        cell.userNameLabel.text = user.displayName
        //userの画像を表示
        let userImageUrl = "https://mb.api.cloud.nifty.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user.objectId
        //kingfisherが画像をセットしてくれる、なかったら違う画像をセットしてくれる
        cell.userImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        
        cell.commentTextView.text = posts[indexPath.row].text
        let imageUrl = posts[indexPath.row].imageUrl
        cell.photoImageView.kf.setImage(with: URL(string: imageUrl))
        
        // Likeによってハートの表示を変える
        if posts[indexPath.row].isLiked == true {
            cell.likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "heart-outline"), for: .normal)
        }
        
        // Likeの数
        //cell.likeCountLabel.text = "\(posts[indexPath.row].likeCount)件"

        // ✨タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
        //cell.timestampLabel.text = posts[indexPath.row].createDate.string()
        
        return cell
    }
    
    //いいねボタンが押された時
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        //もしポストがいいねされていなかったら、もしくはnilだったら
        if posts[tableViewCell.tag].isLiked == false || posts[tableViewCell.tag].isLiked == nil {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                post?.addUniqueObject(NCMBUser.current().objectId, forKey: "likeUser")
                post?.saveEventually { (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        self.loadTimeline()
                    }
                }
            }
   
        } else {
             let query = NCMBObject(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "likeUser")
                    post?.saveEventually { (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadTimeline()
                        }
                    }
                }
            }

        }
    }
    
    //コメントボタンが押された時
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton) {
        <#code#>
    }
    
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton) {
        <#code#>
    }
    
    
    
    func loadTimeline(){
        let query = NCMBQuery(className: "Post")
        
        //順番を降順にする=新しいものがタイムラインの一番上にくるよにする
        query?.order(byDescending: "createDate")
        
        //オブジェクトの取得
        //inbackground=これをやっている間に別のことできますよ
        query?.findObjectsInBackground{ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
            // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [Post]()

                for postObject in result as! [NCMBObject] {
                // ユーザー情報をUserクラスにセット
                let user = postObject.object(forKey: "user") as! NCMBUser
                // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                if user.object(forKey: "active") as? Bool != false {
                    // 投稿したユーザーの情報をUserモデルにまとめる
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as? String

                    // 投稿の情報を取得
                    let imageUrl = postObject.object(forKey: "imageUrl") as! String
                    let text = postObject.object(forKey: "text") as! String
                        
                    // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                    let post = Post(objectId: postObject.objectId, user: userModel, imageUrl: imageUrl, text: text, createDate: postObject.createDate)
                        
                    // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                    let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                    if likeUsers?.contains(NCMBUser.current().objectId) == true {
                        post.isLiked = true
                    } else {
                        post.isLiked = false
                    }
                    
                    //いいねの件数
                    if let likes = likeUsers {
                        //いいねされたらlikecount増えるみたいな
                        //post.likeCount = likes.count
                        }
                    //配列に加える
                    self.posts.append(post)
                    
                    
                    }
                }
                
                //投稿のデータが揃ったらTableViewをリロード
                self.timelineTableView.reloadData()
            }
        }
    }
}
