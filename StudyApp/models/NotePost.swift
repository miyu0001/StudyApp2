//
//  Post.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/18.
//

import UIKit

class NotePost: NSObject {
    var objectId: String
    //資格id
    var id: String
    //誰が投稿したか
    var user: User
    //画像のURL
    var imageUrl: String
    //タイトルの部分のテキスト
    var text: String
    //いつ投稿されたか
    var createDate: Date
    //LIKEを押されているかどうか
    var isLiked: Bool?
    //コメント
    var comments: [Comment]?
    //いいね数
    var likeCount: Int = 0
    

    //それぞれどのタイミングで初期化するか
    //()内で初期化と同時に何か値を渡すことができる
    //オプショナル型ではないものは値を渡すときに必ず何かの値が入らなといけない
    init(objectId: String, id: String,user: User, imageUrl: String, text: String, createDate: Date) {
        self.objectId = objectId
        self.user = user
        self.imageUrl = imageUrl
        self.text = text
        self.createDate = createDate
        self.id = id
    }
}
