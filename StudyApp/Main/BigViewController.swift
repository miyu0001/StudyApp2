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
