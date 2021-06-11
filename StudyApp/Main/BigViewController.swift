//
//  BigViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/21.
//
import Tabman
import Pageboy
import UIKit
import Floaty

class BigViewController: TabmanViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Floatyを生成
        let floaty = Floaty()
        // 開いた時に現れるボタンアイテムを追加
        floaty.addItem("質問", icon: UIImage(named: "question.png")) { item in
            let PostQuestionViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostQuestionViewController") as! PostQuestionViewController
            self.present(PostQuestionViewController, animated: true, completion: nil)
        
        }
        // 開いた時に現れるボタンアイテムを追加
        floaty.addItem("ノート",icon: UIImage(named: "note.png")) { item in
            let PostViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
            PostViewController.modalPresentationStyle = .fullScreen
            self.present(PostViewController, animated: true, completion: nil)
        }
        // viewにFloatyを追加
        view.addSubview(floaty)
        
        floaty.paddingY = 100
        
        dataSource = self
        
        //tabmanの宣言
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        addBar(bar, dataSource: self, at: .top)
        
        bar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //背景色がぼやけないようにする
        bar.backgroundView.style = .clear
        
        //tabManを押した時の色の設定
        bar.buttons.customize { (button) in
            button.tintColor = #colorLiteral(red: 0.1892337203, green: 0.6596918702, blue: 0.9701606631, alpha: 1)
            button.selectedTintColor = #colorLiteral(red: 0.1339888871, green: 0.39494133, blue: 0.9797962308, alpha: 1)
        }
        bar.indicator.overscrollBehavior = .compress
        bar.indicator.weight = .light
        bar.indicator.tintColor = #colorLiteral(red: 0.1253262758, green: 0.388479799, blue: 0.9799692035, alpha: 1)
        bar.scrollMode = .interactive
        
    }
    //子コントローラーの選択
    private lazy var viewControllers: [UIViewController] = {
           [
               storyboard!.instantiateViewController(withIdentifier: "MainViewController"),
               storyboard!.instantiateViewController(withIdentifier: "QuestionTimelineViewController")
           ]
       }()
}

extension BigViewController: PageboyViewControllerDataSource, TMBarDataSource{
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        let titilename = ["ノート","質問"]
        var items = [TMBarItem]()
        
        for i in titilename {
            let title = TMBarItem(title: i)
            items.append(title)
        }
        return items[index]
    }
    //個数の指定
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

// MARK: - FloatyDelegate
extension BigViewController: FloatyDelegate {

    func floatyWillOpen(_ floaty: Floaty) {
        // ボタンが押されてFloatyが開く時に行いたいことを書く
    }

    func floatyWillClose(_ floaty: Floaty) {
        FloatyFactory.floatyWillClose(floaty)
        // ボタンが押されてFloatyが閉じる時に行いたいことを書く
    }
}

final class FloatyFactory {

    // Delegateメソッドでも使うので定数化
    static let openButtonImage = UIImage(named: "consultant")
    static let openButtonImageAfterOpening = UIImage(named: "1x1")
    static let paddingX: CGFloat = 8
    static let paddingY: CGFloat = -20
    static let opendPaddingX: CGFloat = -20
    static let opendPaddingY: CGFloat = -120

    static func makeFloaty(vc: UIViewController & FloatyDelegate) -> Floaty {

        let fab = Floaty()
        // 閉じた状態のボタン画像
        fab.buttonImage = openButtonImage
        // デフォルトのボタンを見えなくするために透明を指定
        fab.buttonColor = .clear
        fab.buttonShadowColor = .clear
        // アイテムもカスタム画像を使用するのでデフォルトの色を透明化
        fab.itemButtonColor = .clear
        // カスタム画像を使用するのでサイズを指定。正円になるもよう
        fab.size = 130
        // 右側からの余白
        fab.paddingX = paddingX
        // 下側からの余白
        fab.paddingY = paddingY
        // アイテム間の余白
        fab.itemSpace = 16
        fab.hasShadow = false
        // アニメーション付けたかったが、アイテムの位置をpaddingで指定しているので、
        // アニメーションをつけると不自然になってしまう
        fab.openAnimationType = .none
        // 開いた際の背景色を指定できる
        //fab.overlayColor = UIColor(hex: "000000", alpha: 0.87)
        // デリゲートメソッドを使うために使用するViewControllerを指定する
        fab.fabDelegate = vc
        // 閉じるボタン
        let closeItem = FloatyItem()
        // サイズを指定しないと画像は小さく表示されてしまう
        closeItem.imageSize = CGSize(width: 76, height: 76)
        closeItem.icon = UIImage(named: "fab-close")
        //closeItem.title = "Close".localized
        // Labelを指定できるので柔軟に見た目を変えられそう
        closeItem.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        closeItem.titleLabel.textAlignment = .right
        // Floatyに定義したアイテムを追加する
        fab.addItem(item: closeItem)

//        let lineItem = FloatyItem()
//        lineItem.imageSize = CGSize(width: 68, height: 68)
//        //lineItem.title = "Inquiry via LINE".localized
//        lineItem.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        lineItem.titleLabel.textAlignment = .right
//        lineItem.icon = UIImage(named: "LINE")
//        lineItem.handler = { item in
//            guard let url = URL(string: "LINEのURLスキームを指定") else { return }
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                //vc.showAlert(title: "LINE App is not installed", message: nil)
//            }
//        }
//        fab.addItem(item: lineItem)

        return fab
    }

    // デリゲートメソッドで行いたいことも共通なのでメソッド化しておく
    static func floatyWillOpen(_ floaty: Floaty) {
        floaty.buttonImage = openButtonImageAfterOpening
        floaty.paddingX = opendPaddingX
        floaty.paddingY = opendPaddingY
    }

    static func floatyWillClose(_ floaty: Floaty) {
        floaty.buttonImage = openButtonImage
        floaty.paddingX = paddingX
        floaty.paddingY = paddingY
    }
}
