//
//  TimeLineDetailViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class TimeLineDetailController: UITableViewController {
    
    var postArray:[TimeLine] = []
    var refreshCtrl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイムラインを非同期で取得する
        self.getTimeLine()
        
        //上に引っ張るとリロードされる動作の設定
        self.refreshControl()

    }
    
    //タイムラインを非同期で取得する
    func getTimeLine(){
        let post_token = postArray[0].post_token
        TimeLineFetcher(post_token: post_token!).download { (items) -> Void in
            self.postArray = items
            self.tableView.reloadData()
        }
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        let post_token = postArray[0].post_token
        TimeLineFetcher(post_token: post_token!).download { (items) -> Void in
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
        return 1
    }
    
    //セルの数を指定する
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    //セルを生成する
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineDetailCell", forIndexPath: indexPath) as! TimeLineDetailTableViewCell
        cell.displayUpdate(postArray[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineDetailCell", forIndexPath: indexPath) as! TimeLineDetailTableViewCell
        let font = UIFont(name: "Times New Roman", size: 14)!
        let text_height = postArray[indexPath.row].heightForComment(font, width: cell.postTV.bounds.width)
        let photo_height = self.calculatePhotoHeight(postArray[indexPath.row])
        let other_height = CGFloat(130)
        return other_height + text_height + photo_height
    }
    
    private func calculatePhotoHeight(post: TimeLine) -> CGFloat {
        if let photo_size:CGSize = post.image_info?.size {
            let boundingRect =  CGRect(x: 0, y: 0, width: photo_size.width, height: CGFloat(MAXFLOAT))
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo_size, boundingRect)
            return rect.size.height
        } else {
            return CGFloat(0)
        }
    }


}
