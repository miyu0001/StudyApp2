//
//  SceneDelegate.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/12.
//

import UIKit
import NCMB

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        let ud = UserDefaults.standard
        //ログインしているかどうか
        let isLogin = ud.bool(forKey: "isLogin")
       
        window = UIWindow(windowScene: scene)
        
        if NCMBUser.current() != nil {
            //ログイン中iphoneのサイズに合わせてwindowを表示してくれる
            //self.window = UIWindow(frame: UIScreen.main.bounds)
            //ログイン中だったらMain.storyboardに行くようにする.bundle.main = このプロジェクトの中にありますよってこと
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            print("Main")
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
            
            //self.window = UIWindow(frame: UIScreen.main.bounds)
            //ログインしてなかったらLogin.storyboardに行くようにする.bundle.main = このプロジェクトの中にありますよってこと
            let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle.main)
            print("Signup")
            //withidetifierでLogin.storyboardの最初のstoryboardにつけた画面が呼び出される
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            
            //代入
            self.window?.rootViewController = rootViewController
            //背景白にしておく
            self.window?.backgroundColor = UIColor.white
            //画面を出す
            self.window?.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

