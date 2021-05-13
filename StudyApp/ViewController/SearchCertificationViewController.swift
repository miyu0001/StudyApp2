//
//  SearchCertificationViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//

import UIKit


class SearchCertificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
 
  
    
    // データ一覧（仮）
    let dataList = [
        "上級システムアドミニストレータ試験",
        "ＩＴストラテジスト試",
        "ＩＴサービスマネージャー試験",
        "プロジェクトマネージャ試験",
        "アプリケーションエンジニア試験",
        "情報処理安全確保支援士",
        "テクニカルエンジニア（データベース）試験",
        "情報セキュリティマネジメント"

    ]
}
