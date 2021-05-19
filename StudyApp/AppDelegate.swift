//
//  AppDelegate.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/12.
//

import UIKit
import NCMB




@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        NCMB.setApplicationKey("b5e12ec814a8695154b6e9d908f542023bf70d35c6e97ce19046dd0c2511495e", clientKey: "14d98c21b14c5d1faf1433374f7d6fa9d1d459d1f616fa9913a91a9c452b9a8e")
        
        let ud = UserDefaults.standard
        //ログインしているかどうか
        let isLogin = ud.bool(forKey: "isLogin")

        if isLogin == true {
            //ログイン中iphoneのサイズに合わせてwindowを表示してくれる
            self.window = UIWindow(frame: UIScreen.main.bounds)
            //ログイン中だったらMain.storyboardに行くようにする.bundle.main = このプロジェクトの中にありますよってこと
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            //withidetifierで最初のstoryboardにつけた画面が呼び出される
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
            //代入
            self.window?.rootViewController = rootViewController
            //背景白にしておく
            self.window?.backgroundColor = UIColor.white
            //画面を出す
            self.window?.makeKeyAndVisible()
        } else {
            //ログインしていなかったら

            self.window = UIWindow(frame: UIScreen.main.bounds)
            //ログインしてなかったらLogin.storyboardに行くようにする.bundle.main = このプロジェクトの中にありますよってこと
            let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle.main)
            //withidetifierでLogin.storyboardの最初のstoryboardにつけた画面が呼び出される
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            //代入
            self.window?.rootViewController = rootViewController
            //背景白にしておく
            self.window?.backgroundColor = UIColor.white
            //画面を出す
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

