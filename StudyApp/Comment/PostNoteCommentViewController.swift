//
//  NoteComment.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/26.
//

import UIKit
import NYXImagesKit
import NCMB
import UITextView_Placeholder
import SVProgressHUD


class PostNoteCommentViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    var postId : String!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //userImage.layer.cornerRadius = userImage.bounds.width / 2
        
        let user = NCMBUser.current()
        
        
    }
    
    @IBAction func postComment(_ sender: Any) {
        SVProgressHUD.show()
        let postObject = NCMBObject(className: "Comment")
        if self.commentTextView.text.count == 0 {
            print("入力されていません")
            return
        }
        postObject?.setObject(self.commentTextView.text!, forKey: "text")
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
    
}