//
//  SearchCertificationViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/13.
//

import UIKit


class SearchCertificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var certificationTableView: UITableView!
    
 
    //ViewControllerから選択されたCell番号を受け取る変数
    var getCell: Int = 0
  
    
    // 資格データ一覧
    let itDataList = [
        "上級システムアドミニストレータ試験",
        "ＩＴストラテジスト試",
        "ＩＴサービスマネージャー試験",
        "プロジェクトマネージャ試験",
        "アプリケーションエンジニア試験",
        "情報処理安全確保支援士",
        "テクニカルエンジニア（データベース）試験",
        "情報セキュリティマネジメント",
        "ウェブデザイン技能検定",
        "応用情報技術者試験",
        "基本情報技術者試験",
        "ITパスポート試験",
        "エンベデッドシステムスペシャリスト試験",
        "情報セキュリティスペシャリスト試験",
        "システム監査技術者試験",
        "システムアーキテクト試験",
        "ネットワークスペシャリスト試験",
        "情報セキュリティーアドミニストレータ試験",
        "テクニカルエンジニア（システム管理）試験",
        "データベーススペシャリスト試験"
    ]
    
    
    let medicaiDataList = [
        "看護師試験",
        "薬剤師試験",
        "診療放射線技師試験",
        "獣医師試験",
        "医師試験",
        "歯科衛生士試験",
        "歯科医師試験",
        "歯科技工士試験",
        "登録販売者（一般医薬品）試験"

    ]
    
    let lowDataList = [
        "法科大学院と新司法試験",
        "司法書士試験",
        "行政書士試験",
        "海事代理士試験",
        "司法試験",
        "知的財産管理技能士",
        "旧司法試験",
        "弁理士試験"
    ]
    
    
    let accountantDataList = [
        "税理士試験",
        "公認会計士試験"
    ]

    let consultingDataList = [
        "社会保険労務士試験",
        "中小企業診断士試験",
        "貸金業務取扱主任者",
        "キャリアコンサルタント"
    ]
    
    let welfareDataList = [
        "作業療法士試験",
        "理学療法士試験",
        "救命艇手試験",
        "義肢装具士試験",
        "臨床検査技師試験",
        "言語聴覚士試験",
        "臨床工学技士試験",
        "視能訓練士試験",
        "助産師試験",
        "保健師試験",
        "社会福祉士試験",
        "保育士資格",
        "柔道整復師試験",
        "はり師試験",
        "介護福祉士試験",
        "保育士採用試験",
        "きゅう師試験",
        "あん摩マッサージ指圧師試験",
        "救急救命士試験"
    ]
    
    let languageDataList = [
        "通関士",
        "通訳案内業",
        "旅行業務主任者/旅行業務取扱管理者"
    ]
    
    let architectureDataList = [
        "ショベルローダ等運転技能者",
        "車両系建設機械運転技能者",
        "ガス主任技術者",
        "建築士試験",
        "移動式クレーン運転士",
        "フォークリフト運転技能者",
        "木造建築物の組立て等作業主任者",
        "土止め支保工作業主任者",
        "建設機械施工技士",
        "管工事施工管理技士",
        "自動ドア施工技能士",
        "玉掛作業者",
        "足場の組立て等作業主任者",
        "型わく支保工の組立て等作業主任者",
        "特定建築物調査員",
        "揚貨装置運転士",
        "建築物等の鉄骨の組立て等作業主任者",
        "デリック運転士",
        "土木施工管理技士",
        "建築設備検査員",
        "コンクリート破砕器作業主任者",
        "クレーン運転士",
        "建築施工管理技士試験",
        "コンクリート造の工作物の解体等作業主任者"
    ]
    
    let electricityDataList = [
        "電気主任技術者試験",
        "電験３種通信講座",
        "電気通信主任技術者試験",
        "工事担任者試験",
        "電気工事施工管理技士",
        "電気工事士試験",
    ]
    
    let wirelessDataList = [
        "総合無線通信士試験",
        "陸上特殊無線技士試験",
        "海上無線通信士試験",
        "海上特殊無線技士試験",
        "陸上無線技術士試験",
        "アマチュア無線技士"

    ]
    
    let industrialDataList = [
        "乾燥設備作業主任者",
        "衛生工学衛生管理者試験",
        "高圧ガス移動監視者",
        "消防設備士",
        "技術士（補）試験",
        "高圧ガス販売主任者",
        "飼料製造管理者",
        "ボイラー据付工事作業主任者試験",
        "普通第１種圧力容器取扱作業主任者",
        "労働安全コンサルタント",
        "ボイラー整備士試験",
        "放射線取扱主任者",
        "高圧室内作業主任者",
        "特定化学物質等作業主任者",
        "特定高圧ガス取扱主任者",
        "ボイラー溶接士試験",
        "危険物取扱者",
        "有機溶剤作業主任者",
        "消防設備点検資格者",
        "酸素欠乏危険作業主任者",
        "エネルギー管理士",
        "作業環境測定士",
        "建築物環境衛生管理技術者",
        "高圧ガス製造保安責任者",
        "木材加工用機械作業主任者",
        "ガンマ線透過写真撮影作業主任者",
        "エックス線作業主任者",
        "廃棄物処理施設技術管理者",
        "ボイラー技士試験",
        "原子炉主任技術者",
        "林業架線作業主任者",
        "労働衛生コンサルタント",
        "衛生管理者試験",
        "液化石油ガス設備士",
        "火薬類（製造・取扱）保安責任者",
        "ボイラー取扱者試験",
        "昇降機検査資格者"
    ]
    
    let sportsDataList = [
        "競輪選手",
        "競艇選手",
        "調教師",
        "騎手",
        "潜水士"
    ]
    
    let managementDataList = [
        "ファイナンシャル・プランニング技能士試験",
        "金融窓口サービス技能士試験",
    ]
    
    let hygieneDataList = [
        "パン製造技能士",
        "レストランサービス技能士",
        "食品衛生管理者",
        "管理栄養士",
        "製菓衛生師",
        "菓子製造技能士",
        "調理師",
        "食品衛生責任者",
        "調理技術審査/調理技能検定",
        "栄養士"
    ]
    
    let envireonmentDataList = [
        "臭気判定士",
        "造園施工管理技士",
        "園芸装飾技能士",
        "造園技能士",
        "浄化槽管理士",
        "一般計量士",
        "浄化槽設備士",
        "環境計量士",
        "公害防止管理者"
    ]
    let aviationDataList = [
        "船橋当直３級海技士（機関）",
        "自動車の整備管理者",
        "自動車検査員",
        "船舶に乗り組む衛生管理者",
        "海技士（通信・電子通信）",
        "事業用操縦士（飛行機・回転翼）",
        "航空管制官",
        "内燃機関海技士",
        "航空整備士",
        "自動車整備士",
        "船内荷役作業主任者",
        "運行管理者",
        "自家用操縦士（飛行機・回転翼）",
        "航空運航整備士",
        "船橋当直３級海技士（航海）",
        "航空工場整備士",
        "海技士（機関）",
        "自家用操縦士（滑空機・飛行船）",
        "航空機関士",
        "運航管理者（航空機）",
        "定期運送用操縦士（飛行機・回転翼）",
        "水先人",
        "小型船舶操縦士",
        "機関当直３級海技士（機関）",
        "航空工場検査員",
        "自動車運転者",
        "海技士（航海）"
    ]
    
    let lifeDataList = [
        "ピアノ調律技能士",
        "フラワー装飾技能士試験",
        "クリーニング師試験",
        "テクニカルイラストレーション技能士",
        "警備業務検定(警備員検定)",
        "理容師試験",
        "美容師試験",
        "気象予報士試験",
        "広告美術仕上げ技能士",
        "商品装飾展示技能士試験"
    ]
    
    let educationDataList = [
        "職業訓練指導員",
        "学芸員（補）試験",
        "高等学校卒業程度認定試験",
        "国立国会図書館職員",
        "幼稚園教諭普通免許状",
        "高等学校教諭普通免許状",
        "養護学校教諭",
        "小学校教諭普通免許状",
        "学校図書館司書教諭",
        "司書（補）試験",
        "中学校教諭普通免許状"

    ]
    
    let psychologydataList = [
        "公認心理師",
        "精神保健福祉士試験"

    ]
    
    //選択されたジャンルの配列の長さ変数
    var DataListLength: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        certificationTableView.delegate = self
        certificationTableView.dataSource = self
        
        //選択されたジャンルによってセルの数を変える
        //getcellの中身が
        switch  getCell {
        //0だったら
        case 0:
            DataListLength = itDataList.count
        case 1:
            DataListLength = medicaiDataList.count
        case 2:
            DataListLength = lowDataList.count
        case 3:
            DataListLength = accountantDataList.count
        case 4:
            DataListLength = consultingDataList.count
        case 5:
            DataListLength = welfareDataList.count
        case 6:
            DataListLength = languageDataList.count
        case 7:
            DataListLength = architectureDataList.count
        case 8:
            DataListLength = electricityDataList.count
        case 9:
            DataListLength = wirelessDataList.count
        case 10:
            DataListLength = industrialDataList.count
        case 11:
            DataListLength = sportsDataList.count
        case 12:
            DataListLength = managementDataList.count
        case 13:
            DataListLength = hygieneDataList.count
        case 14:
            DataListLength = envireonmentDataList.count
        case 15:
            DataListLength = aviationDataList.count
        case 16:
            DataListLength = lifeDataList.count
        case 17:
            DataListLength = educationDataList.count
        case 18:
            DataListLength = psychologydataList.count
        default:
            break
        }
        print(DataListLength,"これDatalistlingth")
    }
    
    
    //セルの数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //DataListの中身の数だけセルを表示させる
        return DataListLength
    }
    
    //　セルの内容を決める　←　合ってるかわからん
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = certificationTableView.dequeueReusableCell(withIdentifier: "certificationCell", for: indexPath)
        
        //選択されたジャンルによってセルの中身を変える
        //getcellの中身が
        switch  getCell {
        //0だったら
        case 0:
            cell.textLabel?.text = itDataList[indexPath.row]
        case 1:
            cell.textLabel?.text = medicaiDataList[indexPath.row]
        case 2:
            cell.textLabel?.text = lowDataList[indexPath.row]
        case 3:
            cell.textLabel?.text = accountantDataList[indexPath.row]
        case 4:
            cell.textLabel?.text = consultingDataList[indexPath.row]
        case 5:
            cell.textLabel?.text = welfareDataList[indexPath.row]
        case 6:
            cell.textLabel?.text = languageDataList[indexPath.row]
        case 7:
            cell.textLabel?.text = architectureDataList[indexPath.row]
        case 8:
            cell.textLabel?.text = electricityDataList[indexPath.row]
        case 9:
            cell.textLabel?.text = wirelessDataList[indexPath.row]
        case 10:
            cell.textLabel?.text = industrialDataList[indexPath.row]
        case 11:
            cell.textLabel?.text = sportsDataList[indexPath.row]
        case 12:
            cell.textLabel?.text = managementDataList[indexPath.row]
        case 13:
            cell.textLabel?.text = hygieneDataList[indexPath.row]
        case 14:
            cell.textLabel?.text = envireonmentDataList[indexPath.row]
        case 15:
            cell.textLabel?.text = aviationDataList[indexPath.row]
        case 16:
            cell.textLabel?.text = lifeDataList[indexPath.row]
        case 17:
            cell.textLabel?.text = educationDataList[indexPath.row]
        case 18:
            cell.textLabel?.text = psychologydataList[indexPath.row]
        default:
            break
        }
        return cell
    }
}
