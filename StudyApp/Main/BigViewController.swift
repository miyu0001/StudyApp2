//
//  BigViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/21.
//
import Tabman
import Pageboy
import UIKit

class BigViewController: TabmanViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        //tabmanの宣言
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        addBar(bar, dataSource: self, at: .top)
        
        bar.layout.transitionStyle = .snap
                addBar(bar.systemBar(), dataSource: self, at: .top)
                bar.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 70.0, bottom: 0.0, right: 70.0)
                bar.buttons.customize { (button) in
                    button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    button.selectedTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                }
                bar.indicator.overscrollBehavior = .compress
                bar.indicator.weight = .light
                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
                self.navigationController?.navigationBar.tintColor = .white
                // ナビゲーションバーのテキストを変更する
                self.navigationController?.navigationBar.titleTextAttributes = [
                // 文字の色
                    .foregroundColor: UIColor.white
                ]
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
