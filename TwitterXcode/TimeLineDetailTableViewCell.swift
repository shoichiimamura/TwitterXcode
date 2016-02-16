//
//  TimeLineTableViewCell.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class TimeLineDetailTableViewCell: UITableViewCell {

    var post:TimeLine?
    @IBOutlet weak var userIV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var searchUserIdButton: UIButton!
    @IBOutlet weak var postTV: UITextView!
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var postHeight: NSLayoutConstraint!
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    //IBOutletやIBActionがロードされた後に呼び出される
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postTV.text = post!.text
        userNameLabel.text = post?.username
        //ユーザのアイコン画像を設定する
        userIV.sd_setImageWithURL(NSURL(string: (post?.userIconURL)!))
        
        //お気に入りボタンの更新処理を設定する
        favoriteButton.addTarget(self, action: "favoriteUpdate:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(favoriteButton)
        
        //お気に入りボタンの初期状態の設定
        favoriteCountLabel.text = String(post!.favoriteCount)
        if post!.favoriteCheck {
            favoriteButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        } else {
            favoriteButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        }
        
    }
    
    //初期設定をする
    func displayUpdate(timeline: TimeLine){
        post = timeline
        //フォントとセルの幅からラベルの高さを返す
        let font = UIFont(name: "System", size: 14)!
        postHeight.constant = timeline.heightForComment(font, width: postTV.bounds.width)
        //アスペクト比に応じた写真の高さを取得して、セルの写真の高さにする
        if let imageURL = post?.imageURL {
            postIV.sd_setImageWithURL(NSURL(string: imageURL))
            let boundingRect =  CGRect(x: 0, y: 0, width: postIV.bounds.width, height: CGFloat(MAXFLOAT))
            let rect  = AVMakeRectWithAspectRatioInsideRect(postIV.bounds.size, boundingRect)
            photoHeight.constant = rect.size.height
        } else {
            photoHeight.constant = CGFloat(0)
        }
    }
    
    //お気に入りボタンの処理
    func favoriteUpdate(sender: UIButton){
        if let post:TimeLine = post {
            //お気に入りボタンが押されると色を変える
            if post.favoriteCheck == false {
                favoriteButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
            } else {
                favoriteButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            }
            //お気に入り状態とお気に入り数を変更する
            post.changeFavoriteState()
            favoriteCountLabel.text = String(post.favoriteCount)
        }
    }
    
}
