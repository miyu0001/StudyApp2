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

class DetailQuestionViewController: UIViewController {
    
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
        
        
        
        self.commentLavel.text = selectedPost?.text as! String
        self.userLabel.text = selectedPost?.user.displayName
        self.timeLabel.text = selectedPost?.createDate as? String

    }
    
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
}
