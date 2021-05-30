//
//  Certification.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/30.
//

import Foundation
import UIKit

class Certification: NSObject {
    
    //資格id
    var certificationId: String
    //なんのジャンルか
    var genreId: [Genre]?
    //名前
    var genleName: String
    
    var certifications : [Certification]?
    
    //それぞれどのタイミングで初期化するか
    //()内で初期化と同時に何か値を渡すことができる
    //オプショナル型ではないものは値を渡すときに必ず何かの値が入らなといけない
    init(certificationId: String, genreId:String, genleName:String) {
        
        self.certificationId = certificationId
        self.genleName = genleName
        
    }
    
}
