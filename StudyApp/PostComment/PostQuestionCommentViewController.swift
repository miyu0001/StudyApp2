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

        let user = NCMBUser.current()
        
        //他のところをタッチしたらキーボードが閉じる
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
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
    

}
