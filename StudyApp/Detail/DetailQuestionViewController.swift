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
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLavel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentReplyButton: UIButton!
    @IBOutlet weak var commentTableview: UITableView!
    
    var selectedUserImage : UIImage!
    
    var commentsText = [String]()
    var users = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableview.dataSource = self
        commentTableview.delegate = self
        
        self.commentLavel.text = selectedPost?.text as! String
        self.userLabel.text = selectedPost?.user.userName
        self.timeLabel.text = selectedPost?.createDate as? String
        
        let user = selectedPost?.user
        
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/qS98cF8iYWpyAH8E/publicFiles/" + user!.objectId as! String
      
        userImage.kf.setImage(with: URL(string: userImageUrl),options: [.forceRefresh])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableview.dequeueReusableCell(withIdentifier: "Cell")!
        let userNameLabel = cell.viewWithTag(1) as! UILabel
        let commentLabel = cell.viewWithTag(2) as! UILabel
        
        userNameLabel.text = users[indexPath.row]
        commentLabel.text = commentsText[indexPath.row]
        
        return cell
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadData() {
        let currentUser = NCMBUser.current()
        
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
                print(error)
                //SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                print(result)
                
                self.users = [String]()
                self.commentsText = [String]()
                
                for postObject in result as! [NCMBObject] {
                    let userData = postObject.object(forKey: "user") as! NCMBObject
                    let user = userData.object(forKey: "userName") as! String
                    let text = postObject.object(forKey: "text") as! String
                    
                    
                    
                    self.users.append(user)
                    self.commentsText.append(text)
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
