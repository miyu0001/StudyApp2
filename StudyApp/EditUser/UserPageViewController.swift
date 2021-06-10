//
//  UserPageViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//

import Foundation
import UIKit
import NCMB
import SVProgressHUD
import CropViewController


class UserPageViewController: UIViewController,UITableViewDataSource, TimelineTableViewCellDelegate, QuestionTableViewCellDelegate,CropViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    var likeNotePosts = [NotePost]()
    var likeQuestionPosts = [QustionPost]()
    var notePosts = [NotePost]()
    var questionPosts = [QustionPost]()
    var likeCount = 0
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userIntroductionTextView: UITextView!
    @IBOutlet weak var userPageTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var toEditButton: UIButton!
    @IBOutlet weak var noteCountLabel: UILabel!
    @IBOutlet weak var questionCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var myQuestionIndex : IndexPath!
    
    var selectSegmentIndex:Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        toEditButton.layer.cornerRadius = 10
        //プロフィール編集ボタンに枠をつける,枠線色
        toEditButton.layer.borderColor = UIColor.gray.cgColor
        //枠線幅
        toEditButton.layer.borderWidth = 1
        
        //画像を資格から丸にする
        userImageView.layer.cornerRadius =  userImageView.bounds.width / 2
        userImageView.layer.masksToBounds = true
        
        userPageTableView.dataSource = self
        
        
        //自分が載せたノートのカスタムビューの取得,xibの登録
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        userPageTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        userPageTableView.rowHeight = 461
        
        //自分が載せた質問のカスタムビューの取得
        let nib2 = UINib(nibName: "QuestionTableViewCell", bundle: Bundle.main)
        userPageTableView.register(nib2, forCellReuseIdentifier: "Cell2")
    }
    
    //画面が戻った時に画像が入っているようにするためにviewwillappearを使う！
    override func viewWillAppear(_ animated: Bool) {
        
        loadDate()
        loadQuestion()
        loadLikeNote()
        loadLikeQuestion()
        //それぞれのユーザーの情報を取得する
        let user = NCMBUser.current()
        
        //NCMBUser.currentを取得してuserという変数に代入する。その時にnilじゃなかったら{}内でuserという定数が使える
        if let user = NCMBUser.current() {
            //それぞれ画像やテキストをNCMBのデータから引っ張って代入
            userDisplayNameLabel.text = user.object(forKey: "displayName") as? String
            userIntroductionTextView.text = user.object(forKey: "introduction") as? String
            self.navigationItem.title = user.object(forKey: "userName") as? String
            self.likeCountLabel.text = String(self.likeCount)
            
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
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        self.selectSegmentIndex = sender.selectedSegmentIndex
        switch sender.selectedSegmentIndex {
        case 0:
            loadDate()
        case 1:
            loadQuestion()
        case 2:
            loadLikeNote()
        case 3:
            loadLikeQuestion()
        default:
            break
        }
        userPageTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.selectSegmentIndex{
        case 0 :
            return notePosts.count
        case 1 :
            return questionPosts.count
        case 2:
            return likeNotePosts.count
        case 3:
            return likeQuestionPosts.count
        default:
            return notePosts.count
        }
    }
    
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = userPageTableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! TimelineTableViewCell
        
        switch self.selectSegmentIndex {
        case 0:
            //自動で高さを変更する
            userPageTableView.estimatedRowHeight = 597
            //timelineTableView.rowHeight <= self.view.bounds.height - 20
            userPageTableView.rowHeight = UITableView.automaticDimension
            let cell = userPageTableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell

            cell.delegate = self
            cell.tag = indexPath.row
            
            let user = notePosts[indexPath.row].user
            cell.userNameLabel.text = user.userName
            
            //userImageViewをkfでURLから画像に変換させる
            let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user.objectId as! String
            //userImageを設定する
            cell.userImageView.kf.setImage(with: URL(string: userImageUrl),options: [.forceRefresh])
            
            //投稿したコメントの設定
            cell.commentLabel.text = notePosts[indexPath.row].text
            //投稿した写真の設定
            let imageUrl = notePosts[indexPath.row].imageUrl as! String
            cell.photoImageView.kf.setImage(with: URL(string: imageUrl))
            
            
            // Likeによってハートの表示を変える（できてない）
            if notePosts[indexPath.row].isLiked == true {
                cell.likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "heart-outline"), for: .normal)
            }
            
            // Likeの数
            //cell.likeCountLabel.text = "\(posts[indexPath.row].likeCount)件"
            
            // タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
            //cell.timestampLabel.text = posts[indexPath.row].createDate()
      
            return cell
        case 1:
            //自動で高さを変更する
            userPageTableView.estimatedRowHeight = 40
            //timelineTableView.rowHeight <= self.view.bounds.height - 20
            userPageTableView.rowHeight = UITableView.automaticDimension
            let cell = userPageTableView.dequeueReusableCell(withIdentifier: "Cell2") as! QuestionTableViewCell
            
            //内容
            cell.delegate = self
            cell.tag = indexPath.row
            
            let user = questionPosts[indexPath.row].user
            
            cell.userNameLabel.text = user.userName
            let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user.objectId
            cell.userImageView.kf.setImage (with: URL (string: userImageUrl), placeholder: UIImage (named: "placeholder.jpg"))
            
            cell.commentLabel.text = questionPosts[indexPath.row].text
    
            // Likeによってハートの表示を変える
            if questionPosts[indexPath.row].isLiked == true {
                cell.likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "heart-outline"), for: .normal)
            }
            
       
            return cell
           
        case 2 :
            //自動で高さを変更する
            userPageTableView.estimatedRowHeight = 597
            //timelineTableView.rowHeight <= self.view.bounds.height - 20
            userPageTableView.rowHeight = UITableView.automaticDimension
            let cell = userPageTableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell

            cell.delegate = self
            cell.tag = indexPath.row
            
            let user = likeNotePosts[indexPath.row].user
            cell.userNameLabel.text = user.userName
            
            //userImageViewをkfでURLから画像に変換させる
            let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user.objectId as! String
            //userImageを設定する
            cell.userImageView.kf.setImage(with: URL(string: userImageUrl),options: [.forceRefresh])
            
            //投稿したコメントの設定
            cell.commentLabel.text = likeNotePosts[indexPath.row].text
            //投稿した写真の設定
            let imageUrl = likeNotePosts[indexPath.row].imageUrl as! String
            cell.photoImageView.kf.setImage(with: URL(string: imageUrl))
            
            
//            // Likeによってハートの表示を変える（できてない）
//            if noteLikePosts[indexPath.row].isLiked == true {
//                cell.likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
//            } else {
//                cell.likeButton.setImage(UIImage(named: "heart-outline"), for: .normal)
//            }
//
            // Likeの数
            //cell.likeCountLabel.text = "\(posts[indexPath.row].likeCount)件"
            
            // タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
            //cell.timestampLabel.text = posts[indexPath.row].createDate()
      
            return cell
        case 3:
            //自動で高さを変更する
            userPageTableView.estimatedRowHeight = 40
            //timelineTableView.rowHeight <= self.view.bounds.height - 20
            userPageTableView.rowHeight = UITableView.automaticDimension
            let cell = userPageTableView.dequeueReusableCell(withIdentifier: "Cell2") as! QuestionTableViewCell
            
            //内容
            cell.delegate = self
            cell.tag = indexPath.row
            
            let user = likeQuestionPosts[indexPath.row].user
            
            cell.userNameLabel.text = user.userName
            let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user.objectId
            cell.userImageView.kf.setImage (with: URL (string: userImageUrl), placeholder: UIImage (named: "placeholder.jpg"))
            
            cell.commentLabel.text = likeQuestionPosts[indexPath.row].text
       
            return cell
        default:
            let cell = userPageTableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
            return cell
        }
    }
    
    //いいねボタンが押された時、どのセル、tableViewが押されたのか引数として引っ張ってくる
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        let currentUser = NCMBUser.current()
        
        if notePosts[tableViewCell.tag].isLiked == false || notePosts[tableViewCell.tag].isLiked == nil {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: notePosts[tableViewCell.tag].objectId, block: { (post, error) in
                post?.addUniqueObject(currentUser?.objectId, forKey: "likeUser")
                post?.saveEventually({ (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        //self.loadTimeline()
                    }
                })
            })
        } else {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: notePosts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "likeUser")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            //self.loadTimeline()
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
            query?.getObjectInBackground(withId: self.notePosts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    // 取得した投稿オブジェクトを削除
                    post?.deleteInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            // 再読込
                            //self.loadTimeline()
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
        if notePosts[tableViewCell.tag].user.objectId == NCMBUser.current().objectId {
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
        //selectedPost = notePosts[tableViewCell.tag]
        
        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toComments", sender: nil)
        
    }
    
    
    
    func loadDate(){
        self.likeCount = 0
        let query = NCMBQuery(className: "Post")
        query?.includeKey("user")
        //投稿した順番
        query?.order(byDescending: "createDate")
        //取得するものが今ログインしている自分のものになる
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //エラー
                print(error)
            } else {
                //notePostsをからにする
                self.notePosts = [NotePost]()
                //NCMBObject型に変換する
                for notePost in result as! [NCMBObject]{
                    if let likeUsers = notePost.object(forKey: "likeUser") as? [String]{
                        self.likeCount += likeUsers.count
                    }
                    
                    //objectの中のuserを持ってくる
                    let user = notePost.object(forKey: "user") as! NCMBUser
                    //UserモデルにNCMBuser型の情報を当てはめる
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as! String
                   
                    //投稿の情報を取得
                    let imageUrl = notePost.object(forKey: "imageUrl") as! String
                    let text = notePost.object(forKey: "text") as! String
                    
                    let post = NotePost(objectId: notePost.objectId, user: userModel, imageUrl: imageUrl, text: text, createDate: notePost.createDate)
                    
                    //likeの状況(自分が過去にlikeしているか？)によってデータを挿入
                    //let likeUser = notePost.object(forKey: "likeUser") as! [String]
                    
                    //配列に加える
                    self.notePosts.append(post)
                    self.noteCountLabel.text = String(self.notePosts.count)
                }
            }
            self.userPageTableView.reloadData()
        })
        
    }
    
    func loadQuestion(){
        let query = NCMBQuery(className: "QuestionPost")
        query?.includeKey("user")
        //投稿した順番
        query?.order(byDescending: "createDate")
        //取得するものが今ログインしている自分のものになる
        query?.whereKey("user", equalTo: NCMBUser.current())

        query?.findObjectsInBackground({ [self] (result, error) in
            if error != nil{
                 //エラー
                print(error)
            } else {
                //questionPostの中身を空にする
                self.questionPosts = [QustionPost]()
                //NCMBobject型に変換する
                for questionPost in result as! [NCMBObject]{
                    let likeUsers = questionPost.object(forKey: "likeUser")as! [String]
                    self.likeCount += likeUsers.count
                    //objectの中のuserを持ってくる
                    let user = questionPost.object(forKey: "user") as! NCMBUser
                    //userモデルにNCMBuser型の情報に当てはめる
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as! String
                    
                    //投稿の情報を取得
//                    let imageUrl = questionPost.object(forKey: "imageUrl") as! Strin/
                    let text = questionPost.object(forKey: "text") as! String
                    
                    let question = QustionPost(objectId: questionPost.objectId, user: userModel, text: text, createDate: questionPost.createDate)
                    //配列に加える
                    self.questionPosts.append(question)
                    self.questionCountLabel.text = String(self.questionPosts.count)
                    self.likeCountLabel.text = String(self.likeCount)
                    
                }
            }
        })
        self.userPageTableView.reloadData()
    }
    
    func loadLikeNote(){
        let query = NCMBQuery(className: "Post")
        query?.includeKey("user")
        //投稿した順番
        query?.order(byDescending: "createDate")
        //取得するものが今ログインしている自分のものになる
        query?.whereKey("likeUser", equalTo: NCMBUser.current().objectId)
        
        query?.findObjectsInBackground{ (result, error) in
            if error != nil {
                print(error)
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.likeNotePosts = [NotePost]()
                for notePost in result as! [NCMBObject]{
                    // ユーザー情報をUserクラスにセット
                    let user = notePost.object(forKey: "user") as! NCMBUser
                    print(user.userName)
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as? String
      
                    //投稿の情報を取得
                    let imageUrl = notePost.object(forKey: "imageUrl") as! String
                    let text = notePost.object(forKey: "text") as! String
                    
                    //データを合わせてpostクラスにセット
                    let post = NotePost(objectId: notePost.objectId, user: userModel, imageUrl: imageUrl, text: text, createDate: notePost.createDate)
                    //配列に加える
                    self.likeNotePosts.append(post)
//                    print(post.objectId)
//                    print(self.likeNotePosts.count)
                }
            }
            //配列に加えた情報をcollectionviewに読み込み
            self.userPageTableView.reloadData()
        }
        
    }
    
    func loadLikeQuestion(){
        let query = NCMBQuery(className: "QuestionPost")
        
        query?.includeKey("user")
        //投稿した順番
        query?.order(byDescending: "createDate")
        
        //取得するものが今ログインしている自分のものになる
        query?.whereKey("likeUser", equalTo: NCMBUser.current().objectId)

        query?.findObjectsInBackground{ (result, error) in
            if error != nil {
                print(error)
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.likeQuestionPosts = [QustionPost]()
                for questionpost in result as! [NCMBObject]{
                    // ユーザー情報をUserクラスにセット
                    let user = questionpost.object(forKey: "user") as! NCMBUser
                    print(user.userName)
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as? String
      
                    //投稿の情報を取得
                    
                    let text = questionpost.object(forKey: "text") as! String
                    
                    //データを合わせてpostクラスにセット
                    let post = QustionPost(objectId: questionpost.objectId, user: userModel, text: text, createDate: questionpost.createDate)
                    //配列に加える
                    self.likeQuestionPosts.append(post)
//                    print(post.objectId)
//                    print(self.likeNotePosts.count)
                }
            }
        }
    }
}
