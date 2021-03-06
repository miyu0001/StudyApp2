//
//  TimelineTableViewCell.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/17.
//

import UIKit

protocol TimelineTableViewCellDelegate {
    //いいねボタンが押された
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton)
    //メニューボタンが押された
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton)
    //コメントボタンが押された
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton)
}

class TimelineTableViewCell: UITableViewCell {
    
    var delegate: TimelineTableViewCellDelegate?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func like(button: UIButton) {
        self.delegate?.didTapLikeButton(tableViewCell: self, button: button)
    }
    @IBAction func openMenu(button: UIButton) {
        self.delegate?.didTapMenuButton(tableViewCell: self, button: button)
    }

    @IBAction func showComments(button: UIButton) {
        self.delegate?.didTapCommentsButton(tableViewCell: self, button: button)
    }
    
}
