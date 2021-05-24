//
//  PostQuestionViewController.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/22.


import UIKit
import NYXImagesKit
import NCMB
import UITextView_Placeholder
import SVProgressHUD

class PostQuestionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    //let placeholderImage = UIImage(named: "photo-placeholder")
    
    var resizedImage: UIImage!
    
    
    
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.isEnabled = false
        postTextView.placeholder = "キャプションを書く"
        postTextView.delegate = self
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    
    @IBAction func sharePhoto() {
        SVProgressHUD.show()
        
        //let data = resizedImage.pngData()
        // ここを変更（ファイル名無いので）
        //let file = NCMBFile.file(with: data) as! NCMBFile
        //file.saveInBackground({ (error) in
//            if error != nil {
//                SVProgressHUD.dismiss()
//                let alert = UIAlertController(title: "画像アップロードエラー", message: error!.localizedDescription, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//
//                })
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                if self.postTextView.text.count == 0 {
//                    print("入力されていません")
//                    return
//                }
//            }
//        }) { (progress) in
//            print(progress)
//        }
    }
    
    func confirmContent() {
        if postTextView.text.count > 0  {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }
    
    @IBAction func cancel() {
        if postTextView.isFirstResponder == true {
            postTextView.resignFirstResponder()
        }
        
        let alert = UIAlertController(title: "投稿内容の破棄", message: "入力中の投稿内容を破棄しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.postTextView.text = nil
            self.confirmContent()
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

