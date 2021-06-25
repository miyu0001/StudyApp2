//
//  SerchViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/12.
//

import UIKit


class SerchgenreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var GenreTableView: UITableView!

    // ジャンルデータ一覧
    let genreDataList = [
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
    
    //選択されたセルを覚える変数
    var chosenCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        //データメソッドをファイル内で処理する
        GenreTableView.dataSource = self
        GenreTableView.delegate = self
    }
    
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreDataList.count
    }
    
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell")!
        cell.textLabel?.text = genreDataList[indexPath.row]
        return cell
    }
    //セルが選択された時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移の準備
        performSegue(withIdentifier: "toSearchCertificationViewController", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //segue準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexpath = GenreTableView.indexPathForSelectedRow!
        
        //遷移先のViewControllerのインスタンスを生成
        let secVC = segue.destination as! SearchCertificationViewController
        //SearchCertificationViewControllernogetcellに選択された画像を設定する
        
        secVC.getCell = indexpath.row
    
    }
    
    
}
    


