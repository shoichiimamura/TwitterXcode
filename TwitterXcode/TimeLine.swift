//
//  TimeLine.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import SwiftyJSON

class TimeLine {
    
    struct ImageOfTimeLine {
        private (set) var url:String?
        private (set) var size: CGSize?
    }
    
    private (set) var post_token:String?
    private (set) var text:String?
    private (set) var latitude:Double?
    private (set) var longitude:Double?
    private (set) var image_info:ImageOfTimeLine?
    
    private (set) var user_token:String?
    private (set) var username:String?
    private (set) var user_identifier: String?
    private (set) var icon_image_url:String?
    
    private (set) var favorite_check:Bool = false
    private (set) var favorite_count:Int = 0
    
    private (set) var retweet_check:Bool = false
    private (set) var retweet_count:Int = 0
    
    init(
            post_token: String,
            favorite_check: Bool,
            favorite_count: Int,
            retweet_check: Bool,
            retweet_count: Int,
            user_token: String,
            username: String,
            user_identifier: String,
            icon_image_url: String,
            text: String,
            image_url: String?,
            image_size: CGSize?,
            latitude: Double,
            longitude: Double
        ){
            self.post_token = post_token
            self.favorite_check = favorite_check
            self.favorite_count = favorite_count
            self.retweet_check = retweet_check
            self.retweet_count = retweet_count
            self.user_token = user_token
            self.username = username
            self.user_identifier = user_identifier
            self.icon_image_url = icon_image_url
            self.text = text
            self.image_info = ImageOfTimeLine(url: image_url, size: image_size)
            self.latitude = latitude
            self.longitude = longitude
    }
    
    //お気に入り状態の切り替え
    func changeFavoriteState(){
        if self.favorite_check == true {
            self.favorite_count -= 1
        } else {
            self.favorite_count += 1
        }
        self.favorite_check = !self.favorite_check
    }
    
    //リツイート状態の切り替え
    func changeRetweetState(){
        if self.retweet_check == true {
            self.retweet_count -= 1
        } else {
            self.retweet_count += 1
        }
        self.retweet_check = !self.retweet_check
    }
    
    //投稿文のラベルの高さを返す
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self.text!).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        //数値式以上の最小の整数を戻す
        return ceil(rect.height)
    }

}

class TimeLineWrapper {
    
    func getInstance(json:JSON) -> TimeLine {
        
        let timeLine = TimeLine (
            post_token: json["post"]["post_token"].stringValue,
            favorite_check: json["favorite_state"].boolValue,
            favorite_count: json["favorite_count"].intValue,
            retweet_check: json["retweet_state"].boolValue,
            retweet_count: json["retweet_count"].intValue,
            user_token: json["user"]["user_token"].stringValue,
            username: json["user"]["username"].stringValue,
            user_identifier: json["user"]["user_identifier"].stringValue,
            icon_image_url: json["user"]["icon_image_url"].stringValue,
            text: json["post"]["text"].stringValue,
            image_url: self.getImageURL(json),
            image_size: self.getImageSize(json),
            latitude: json["post"]["latitude"].doubleValue,
            longitude: json["post"]["longitude"].doubleValue
        )
        
        return timeLine
    }
    
    //画像のURLを指定する
    private func getImageURL(json: JSON) -> String? {
        if json["image_url"] != nil && json["image_url"].stringValue.utf16.count != 0 {
            return json["image_url"].stringValue
        } else {
            return nil
        }
    }
    
    private func getImageSize(json: JSON) -> CGSize? {
        if json["post"]["image_width"] != nil && json["post"]["image_height"] != nil {
            let width = json["post"]["image_width"].doubleValue
            let height = json["post"]["image_height"].doubleValue
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
}
