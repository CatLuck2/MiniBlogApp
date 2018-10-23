//
//  ShareViewController.swift
//  MiniBlogApp
//
//  Created by 藤澤洋佑 on 2018/10/05.
//  Copyright © 2018年 Fujisawa-Yousuke. All rights reserved.
//

/*
 
 ・投稿ボタンを押すと、４つのデータがFirebaseに保存される
    ・TimeLineViewControllerに戻る
 ・”アルバムから選択する”を押すと、アルバム画面が開く
    ・UIImagePickerController
    ・写真を選択すると、ImageViewに表示される
 ・画面をタップすると、キーボードが閉じる
    ・touchesBegan
    ・resignFirstResponder()
 
 */

import UIKit
import SDWebImage
import Firebase

class ShareViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    //アルバムで選択した画像のURL
    var url = String()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var categoryField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func albumPicker(_ sender: Any) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    //　撮影が完了時した時に呼ばれる
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            
            imageView.image = pickedImage

        } else {
            
            print("画像を設定できませんでした。")
            
        }
        
        //カメラ画面(アルバム画面)を閉じる処理
        picker.dismiss(animated: true, completion: nil)
        
    }

    //投稿ボタン
    @IBAction func postButton(_ sender: Any) {
        
        //Firebaseにデータを保存する
        let rootRef = Database.database().reference(fromURL: "https://miniblogfirebase.firebaseio.com/").child("post").childByAutoId()
        //ストレージの参照URL
        let storageRef = Storage.storage().reference(forURL: "gs://miniblogfirebase.appspot.com")
        let key = rootRef.key
        let imageRef = storageRef.child("Users").child("\(key).jpg")
        
        var data = NSData()
        
        if let image = imageView.image {
            data = image.jpegData(compressionQuality: 0.01)! as NSData
            print("圧縮されました")
        }
        
        let uploadTask = imageRef.putData(data as Data, metadata: nil) { (metaData, error) in
            
            if error != nil {
                print("画像のエラーです")
                return
            } else {
                
                imageRef.downloadURL(completion: { (url, error) in
                    
                    if url != nil {
                        
                        let feed = ["title":self.titleField.text ?? "title",
                                    "sentence":self.textView.text ?? "sentence",
                                    "pictureURLString":url?.absoluteString ?? "url",
                                    "category":self.categoryField.text ?? "category"] as [String:Any]
                        
                        rootRef.setValue(feed)
                        
                    } else {
                        print("投稿できませんでした")
                    }
                    
                })
                
            }
            
        }

        uploadTask.resume()
        dismiss(animated: true, completion: nil)
        
    }
    
    //キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleField.resignFirstResponder()
        categoryField.resignFirstResponder()
        textView.resignFirstResponder()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
