//
//  Genre.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/30.
//

import Foundation
import UIKit

class Genre: NSObject {
    
    //資格id
    //var id: String
    //名前????
    var genleName: String
    //
    var certifications : [Certifications]?
    
    //それぞれどのタイミングで初期化するか
    //()内で初期化と同時に何か値を渡すことができる
    //オプショナル型ではないものは値を渡すときに必ず何かの値が入らなといけない
    init(objectId:String, id:String, genleName:String) {
        
        self.genleName = genleName
        //self.id = id
    
        
    }
}
