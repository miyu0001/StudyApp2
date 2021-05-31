//
//  Certification.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/30.
//

import Foundation
import UIKit

class Certifications: NSObject {
   
    //資格id
    //var id: String
    //なんのジャンルか?
    var genreId: [Genre]?
    //名前??
    var CertificationName: String
 
    //それぞれどのタイミングで初期化するか
    //()内で初期化と同時に何か値を渡すことができる
    //オプショナル型ではないものは値を渡すときに必ず何かの値が入らなといけない
    init(id: String, genreId:String, CertificationName:String) {
        
       // self.id = id
        self.CertificationName = CertificationName
    
    }
    
}
