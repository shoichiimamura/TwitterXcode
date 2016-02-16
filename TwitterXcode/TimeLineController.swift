//
//  TimeLineController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class TimeLineController: UITableViewController {
    
    var postArray:[TimeLine] = []
    var refreshCtrl:UIRefreshControl!
    
    @IBAction func showPostView(sender: AnyObject) {
        self.showPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイムラインを非同期で取得する
        self.getTimeLine()
        
        //上に引っ張るとリロードされる動作の設定
        self.refreshControl()

    }
    
    //投稿画面へ遷移する
    func showPost(){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PostCtrl")
            as? PostController {
                self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    //タイムラインを非同期で取得する
    func getTimeLine(){
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.tableView.reloadData()
        }
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.refreshCtrl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    //上に引っ張るとリロードされる動作の設定
    private func refreshControl(){
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshCtrl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshCtrl)
    }

    //セクション数を指定する
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    //セルの数を指定する
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    //セルを生成する
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineCell", forIndexPath: indexPath) as! TimeLineTableViewCell
        cell.displayUpdate(postArray[indexPath.row])
        return cell
    }
    
    //詳細画面へ遷移する
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TimeLineDetailCtrl") as? TimeLineDetailController {
            vc.postArray.append(self.postArray[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
