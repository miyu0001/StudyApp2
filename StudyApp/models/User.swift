//
//  User.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/18.
//

import UIKit

class User: NSObject {
    var objectId: String
    //ユーザー名
    var userName: String
    //表示名
    var displayName: String?
    //自己紹介
    var introduction: String?

    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
}
