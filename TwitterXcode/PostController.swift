//
//  PostControllerViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class PostController: UIViewController, UITabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var imageURL:String = ""
    private var latitude: Double?
    private var longitude: Double?
    
    @IBOutlet weak var postTV: UITextView!
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var selectImageTB: UITabBar!
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    //投稿する画像を選択する際に必要な処理をする
    private func setPhoto(imagePath: String){
        self.imageURL = imagePath
        postIV.image = UIImage(named:imagePath)
        if let height = postIV.image?.size.height {
            if height <= CGFloat(190) {
                self.photoHeight.constant = height
            } else {
                self.photoHeight.constant = CGFloat(190)
            }
        }
    }
    
    @IBAction func backView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postUpload(sender: AnyObject) {
        if let latitude = self.latitude,
            let longitude = self.longitude,
            let text = postTV.text {
                let post = PostWrapper.getInstance(["text": text, "ImageURL": imageURL, "latitude": latitude, "longitude": longitude])
                if postIV.image != nil {
                    //画像無しの場合
                    PostDispatcher(post: post).upload{(result) -> Void in
                        if result {
                            print("テキストの投稿が完了しました")
                        } else {
                            print("テキストの投稿が失敗しました")
                        }
                    }
                } else {
                    //画像無しの場合
                    PostDispatcher(post: post).uploadWithImage{(result) -> Void in
                        if result {
                            print("画像とテキストの投稿が完了しました")
                        } else {
                            print("画像とテキストの投稿が失敗しました")
                        }
                    }
                }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectImageTB.delegate = self
        
        photoHeight.constant = CGFloat(0)
        
        //取得した位置情報を設定する
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let latitude = app.sharedUserData["latitude"] as? Double,
            let longitude = app.sharedUserData["longitude"] as? Double {
                self.latitude = latitude
                self.longitude = longitude
                print("ユーザの投稿時の緯度経度：\(latitude), \(longitude)")
        }
    }
    
    //押されたタブをタグで識別して処理を分ける
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag {
        case 0:
            self.setPhoto("Image02.jpg")
        case 1:
            //カメラロールへアクセス
            self.pickImageFromLibrary()
        default:
            print("item.tag:\(item.tag)")
        }
    }
    
    //ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    //写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            if let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL] {
                print(String(assetURL))
                //self.setPhoto(imageのPath)
                //このURLを取り出すにはAssetLibrary.Frameworkが必要になる
            }
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }




}