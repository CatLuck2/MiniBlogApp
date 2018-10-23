//
//  ViewController.swift
//  MiniBlogApp
//
//  Created by CatLuck2  on 2018/10/05.
//  Copyright © 2018年 CatLuck2 . All rights reserved.
//

/*
 「必要な機能」
 ・ログイン機能
    ・UserDefaultsにユーザー名があるかどうか
        ・初回は、ユーザー名をUserDefaultsに登録
        ・次回以降は、自動的にログイン
    ・もし入力値がnillなら、アラートを出す
        ・EMAlertController
 
 
 */

import UIKit
import EMAlertController

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //もしユーザー名が保存されてるなら
        if let _ = UserDefaults.standard.object(forKey: "userName") {
            //ボタンの文字を"ログイン"に変更
            loginButton.setTitle("ログイン", for: .normal)
        //保存されてないなら
        } else {
            loginButton.setTitle("会員登録", for: .normal)
        }
        
    }

    @IBAction func login(_ sender: Any) {
        
        //もしユーザー名が保存されてるなら
        if let _ = UserDefaults.standard.object(forKey: "userName") {
            
            //もし入力した値が保存したユーザー名と同じなら
            if textField.text ==  UserDefaults.standard.object(forKey: "userName") as? String {
                
                //遷移
                performSegue(withIdentifier: "goTimeLine", sender: nil)
                
            //違うなら
            } else {
                
                //アラート作成
                let alert = EMAlertController(title: "ユーザー名が正しくありません。",message: "")
                //アクション作成
                let action = EMAlertAction(title: "OK", style: .cancel)
                //アラートにアクションを追加する
                alert.addAction(action: action)
                //アラートを表示
                present(alert, animated: true, completion: nil)
                
            }
            
        //もし保存されてないなら
        } else {
            
            //もし入力フォームに何もなければ
            if textField.text != "" {
                
                //UserDefaultsの変数
                let ud = UserDefaults.standard
                //ユーザー名をUDに保存
                ud.set(textField.text, forKey: "userName")
                //画面遷移
                performSegue(withIdentifier: "goTimeLine", sender: nil)
                
            //もし入力されてるなら
            } else {
                
                //アラート
                let alert = EMAlertController(title: "ユーザー名を入力してください", message: "")
                //アクション
                let action = EMAlertAction(title: "OK", style: .cancel)
                //アラートにアクションを追加する
                alert.addAction(action: action)
                //アラートを表示
                present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    @IBAction func reminderUsername(_ sender: Any) {
        
        if let _ = UserDefaults.standard.object(forKey: "userName") {
            
            //アラート
            let alert = EMAlertController(title: "あなたのユーザー名", message: UserDefaults.standard.object(forKey: "userName") as? String )
            //アクション作成
            let action = EMAlertAction(title: "OK", style: .cancel)
            //アラートにアクションを追加する
            alert.addAction(action: action)
            //アラートを表示
            present(alert, animated: true, completion: nil)
            
        } else {
            
            //アラート
            let alert = EMAlertController(title: "まだユーザー名が登録されてません", message: "")
            //アクション作成
            let action = EMAlertAction(title: "OK", style: .cancel)
            //アラートにアクションを追加する
            alert.addAction(action: action)
            //アラートを表示
            present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    //画面をタップするとキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    
}

