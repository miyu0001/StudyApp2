//
//  SerchViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/12.
//

import UIKit


class SerchgenreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    // ジャンルデータ一覧
    let genredataList = [
        "IT資格/パソコン系",
        "医療系",
        "法律系",
        "会計系",
        "コンサル系",
        "介護/福祉系",
        "語学/国際系",
        "建築/施工系",
        "電気系",
        "無線系",
        "工業系",
        "スポーツ系",
        "経営/法務系",
        "調理/衛生/飲食系",
        "自然/環境系",
        "車両/航空/船舶系",
        "生活系",
        "教育系",
        "心理系",
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
    


