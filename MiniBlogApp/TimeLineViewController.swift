//
//  TimeLineViewController.swift
//  MiniBlogApp
//
//  Created by CatLuck2  on 2018/10/05.
//  Copyright © 2018年 CatLuck2 . All rights reserved.
//

/*

 ・タイムラインに戻るたびに、tableViewを更新
    ・tableView.reloadData()
 ・３つのラベル（日時、カテゴリ、本文）をtagで生成
    ・cell.viewWithTag(1) as! UILabel
 ・投稿を削除する
    ・cell...editingStyle
    ・Firebaseから該当するデータ群を削除
 ・下スワイプで更新
    ・refleshControl()
 ・Firebaseに保存したデータを一括表示
    ・投稿日時、カテゴリ、タイトル、画像、本文
 ・最新の投稿を上から順に表示
 
 FirebaseDatabaseURL:https://miniblogfirebase.firebaseio.com/
 
 */

import UIKit
import SDWebImage
import Firebase

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Postクラスに関連する変数
    var posts = [Post]()
    var posst = Post()
    
    //refleshのインスタンス
    let reflesh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        reflesh.attributedTitle = NSAttributedString(string: "更新する")
        reflesh.addTarget(self, action: #selector(update), for: .valueChanged)
        tableView.addSubview(reflesh)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update_Firebase()
        
        tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        let daytimeLabel = cell.viewWithTag(1) as! UILabel
//        daytimeLabel.text = posts[indexPath.row].daytime
        
        let categoryLabel = cell.viewWithTag(2) as! UILabel
        categoryLabel.text = self.posts[indexPath.row].category
        
        let titleLabel = cell.viewWithTag(3) as! UILabel
        titleLabel.text = self.posts[indexPath.row].title
        
        let imageView = cell.viewWithTag(4) as! UIImageView
        let imageURL = URL(string: self.posts[indexPath.row].pictureURLString as String)!
        imageView.sd_setImage(with: imageURL, completed: nil)
        imageView.clipsToBounds = true
        
        let sentenceLabel = cell.viewWithTag(5) as! UILabel
        sentenceLabel.text = self.posts[indexPath.row].sentence
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 460
    }
    
    //データ更新メソッドを実行
    @objc func update() {
        
        //データを更新
        update_Firebase()
        //更新をストップ
        reflesh.endRefreshing()
        print(posts)
    }
    
    //データ更新メソッド
    func update_Firebase() {
        
        //データベースの参照URL
        let ref = Database.database().reference()
        
        self.posst = Post()
        
        //post階層のデータをsnapで取り出す
        //データを["???":データの型]で取得する
        ref.child("post").observeSingleEvent(of: .value) { (snap,error) in
            
            
            let snapData = snap.value as? [String:NSDictionary]
            
            if snapData == nil {
                return
            }
            
            self.posts = [Post]()
            
            for (_,post) in snapData! {
                
                print("表示します")
                
                self.posst = Post()
                
                if let title = post["title"] as? String, let sentence = post["sentence"] as? String, let pictureURLString = post["pictureURLString"] as? String, let category = post["category"] as? String {
                    
                    print("表示されます") //ここは通ります。
                    
                    self.posst.title = title
                    self.posst.sentence = sentence
                    self.posst.pictureURLString = pictureURLString
                    self.posst.category = category
                    
                    //Databaseにあるデータを全て表示してくれてます。
                    print("\(self.posst.title), \(self.posst.sentence), \(self.posst.pictureURLString), \(self.posst.category)")
                    
                }
                
                self.posts.append(self.posst)
                
                print(self.posts)
                
            }
            
            self.tableView.reloadData()
            
        }
        
        
    }

}
