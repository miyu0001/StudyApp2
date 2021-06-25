//
//  DetailQuestionViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/27.
//

import UIKit
import NCMB
import Kingfisher
import SwiftData
import SVProgressHUD

class DetailQuestionViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
  
    //選ばれたpostをそのまま渡してる（投稿全体をバラバラにせずに）
    var selectedPost: QustionPost?
    var comments = [Comment]()
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLavel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentReplyButton: UIButton!
    @IBOutlet weak var commentTableview: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var selectedUserImage : UIImage!
    
    var commentsText = [String]()
    var users = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        //　ナビゲーションバーの背景色
        navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // その他UIColor.white等好きな背景色
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = #colorLiteral(red: 0.2196078431, green: 0.4078431373, blue: 0.8901960784, alpha: 1)
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor : UIColor.black
        ]
        // セパレーターの左側の余白を消す
        commentTableview.separatorInset = UIEdgeInsets.zero
        //自動で高さを変更する
        commentTableview.estimatedRowHeight = 30
        //timelineTableView.rowHeight <= self.view.bounds.height - 20
        commentTableview.rowHeight = UITableView.automaticDimension
        
        //セルの選択不可
        self.commentTableview.allowsSelection = false
        
        commentTableview.dataSource = self
        commentTableview.delegate = self
        
        self.commentLavel.text = selectedPost?.text as! String
        self.commentLavel.sizeToFit()
        self.commentLavel.numberOfLines=0
        self.userLabel.text = selectedPost?.user.userName
        self.timeLabel.text = selectedPost?.createDate as? String
        
        let user = selectedPost?.user
        
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user!.objectId 
        print(userImageUrl)
      
        userImage.kf.setImage(with: URL(string: userImageUrl),options: [.forceRefresh])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
            //タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
            dateFormatter.dateFormat = "MM/dd HH"
            let dateString = dateFormatter.string(from: self.selectedPost!.createDate)
            self.timeLabel.text = dateString + "時"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableview.dequeueReusableCell(withIdentifier: "Cell")!
        let userImage = cell.viewWithTag(1) as! UIImageView
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        
        //commentはCommentのモデルが配列としていっぱい入ってるけど、それぞれに情報は入っていない
       
        let user = comments[indexPath.row].user
        //userImageViewをkfでURLから画像に変換させる
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user.objectId 
        
        //userImageを設定する
        userImage.kf.setImage(with: URL (string: userImageUrl), placeholder: UIImage (named: "placeholder.jpg"))
 
        
        let commentLabel = cell.viewWithTag(2) as! UILabel
        commentLabel.text = comments[indexPath.row].text
        let userLabel = cell.viewWithTag(3) as! UILabel
        userLabel.text = user.userName
        return cell
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadData() {
      
        
        let query = NCMBQuery(className: "postComment")

        // 降順
        query?.order(byDescending: "createDate")
        
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        
        // オブジェクトの取得
        query?.whereKey("postId", equalTo: selectedPost?.objectId)
        //result = とってきた結果が入る変数
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //エラーの時
                print(error as Any)
                //SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                //for文が始まる前に空にする
                self.comments = []
//                self.users = [String]()
//                self.commentsText = [String]()
                
                for postObject in result as! [NCMBObject] {
                    //userが NCMBUser型
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    let text = postObject.object(forKey: "text") as! String
                    //userの情報を使ってUser型にする
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    //Commentのモデルもまとめる
                    let commentModel = Comment(postId: self.selectedPost!.objectId, user: userModel, text: text, createDate: postObject.createDate)
                    
                    //データを追加していく
                    self.comments.append(commentModel)
                
                }
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.commentTableview.reloadData()
            }
        })
    }
    
    @IBAction override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments"{
            let commentVC = segue.destination as! PostQuestionCommentViewController
            commentVC.postId = selectedPost?.objectId as! String
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 55
    }
}
