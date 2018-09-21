//
//  WordDetailViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/30.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import ChameleonFramework
import FirebaseStorage

class WordDetailViewController: UIViewController ,UIScrollViewDelegate ,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Totalのページ数
    var pageNum:Int!

    var screenSize:CGRect!
    
    var selectDic = myDic(dictitle: "",dicid: "")
    
    var userid = ""
    
    var dicid = ""
    
    var selectrow = -1
    
    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    var storage = Storage.storage()
    
    static let LABEL_TAG = 100
    // 現在表示されているページ
    var page: Int = 0
    // ScrollViewをスクロールする前の位置
    private var startPoint: CGPoint!
    // 表示するページビューの配列
    private var pageViewArray: [UIView] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       scrollView.delegate = self
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //selectDic.fetchWordList(row: Int(selectDic.dicid)!)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(WordDetailViewController.tapped(_:)))
        
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        //navigationController?.navigationBar.backgroundColor = UIColor.clear
        //navigationController?.navigationBar.alpha = 0.7


        
         //navigationController?.hidesBarsOnTap = true
        
        //self.navigationController?.view.addSubview(self.scrollView)
        //self.scrollView.addSubview((navigationController?.navigationBar)!)
        //navigationController?.navigationBar.frame.origin.y = 100
        
       // scrollView.frame.origin.x = 0
       // scrollView.frame.origin.y = 0
        
        //　scrollViewの表示サイズ
        let size = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        // 5ページ分のcontentSize
        let contentRect = CGRect(x: 0, y: 0, width: size.width * CGFloat(selectDic.words.count), height: size.height)
        let contentView = UIView(frame: contentRect)
        
        let wordeditbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Create"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.wordedit))
        self.navigationItem.setRightBarButtonItems([wordeditbutton], animated: true)
        
        pageNum = selectDic.words.count
        
        for i in 0 ..< pageNum {
            //let page = makePage(x: CGFloat(i * Int(view.frame.width)), i: i)
            let pageview = UIView(frame: CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height))
            //self.navigationController?.view.addSubview(pageview)
            //pageview.addSubview((navigationController?.view)!)
            let WordName = UITextView()
            WordName.text = selectDic.words[i].wordtitle
            WordName.font = UIFont(name: "Hiragino Sans", size: 30)
            WordName.backgroundColor = .white
            WordName.frame.size.width = size.width - 10
            WordName.sizeToFit()
            WordName.frame.origin.x = 10
            WordName.frame.origin.y = 20
            WordName.tag = WordDetailViewController.LABEL_TAG
            WordName.isEditable = false
            
            let storageRef = storage.reference()
            let reference = storageRef.child("alldictionarylist/\(dicid)/words/\(selectDic.words[i].wordid!)")
            print("wordid:\(selectDic.words[i].wordid!)")
            reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    // Uh-oh, an error occurred!
                    let WordMean = UITextView()
                    WordMean.text = self.selectDic.words[i].wordmean
                    WordMean.font = UIFont(name: "Hiragino Sans", size: 15)
                    WordMean.backgroundColor = .white
                    WordMean.frame.size.width = size.width - 20
                    WordMean.sizeToFit()
                    WordMean.center = pageview.center
                    WordMean.frame.origin.x = 10
                    WordMean.frame.origin.y = WordName.frame.height + 20
                    WordMean.tag = WordDetailViewController.LABEL_TAG
                    WordMean.isEditable = false
                    WordMean.isScrollEnabled = false
                    WordMean.isSelectable = false
                    
                    let pageviewscroll = UIScrollView()
                    pageviewscroll.addSubview(WordName)
                    pageviewscroll.addSubview(WordMean)
                    pageviewscroll.contentSize = CGSize(width: size.width, height: WordName.frame.size.height + WordMean.frame.size.height + 100)
                    pageviewscroll.contentOffset = CGPoint(x: 0, y: 0)
                    pageviewscroll.frame = CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height + 100)
                    
                    
                    contentView.addSubview(pageviewscroll)
                    self.pageViewArray.append(pageviewscroll)
                    
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    
                    let WordPicture = UIImageView()
                    WordPicture.frame = CGRect(x: 20, y: WordName.frame.height + 20, width: size.width - 40, height: (size.width - 40)*3/4)
                    WordPicture.contentMode = UIViewContentMode.scaleAspectFit
                    WordPicture.image = image
                    WordPicture.tag = WordDetailViewController.LABEL_TAG
                    
                    let WordMean = UITextView()
                    WordMean.text = self.selectDic.words[i].wordmean
                    WordMean.font = UIFont(name: "Hiragino Sans", size: 15)
                    WordMean.backgroundColor = .white
                    WordMean.frame.size.width = size.width - 20
                    WordMean.sizeToFit()
                    WordMean.center = pageview.center
                    WordMean.frame.origin.x = 10
                    WordMean.frame.origin.y = WordName.frame.height + WordPicture.frame.height + 40
                    WordMean.tag = WordDetailViewController.LABEL_TAG
                    WordMean.isEditable = false
                    WordMean.isScrollEnabled = false
                    WordMean.isSelectable = false
                    
                    let pageviewscroll = UIScrollView()
                    pageviewscroll.addSubview(WordName)
                    pageviewscroll.addSubview(WordPicture)
                    pageviewscroll.addSubview(WordMean)
                    pageviewscroll.contentSize = CGSize(width: size.width, height: WordName.frame.size.height + WordMean.frame.size.height + WordPicture.frame.height + 100)
                    pageviewscroll.contentOffset = CGPoint(x: 0, y: 0)
                    pageviewscroll.frame = CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height + 100)
                    
                    contentView.addSubview(pageviewscroll)
                    self.pageViewArray.append(pageviewscroll)
                }
            }
            
            //if let imageDate:NSData = UserDefaults.standard.object(forKey: selectDic.words[i].wordpicturekey) as? NSData {
            
            /*
            let filename = getDocumentsDirectory().appendingPathComponent(selectDic.words[i].wordpicturekey)
            
            if let imageDate:NSData = NSData(contentsOf: filename){
                
                let WordPicture = UIImageView()
                WordPicture.frame = CGRect(x: 20, y: WordName.frame.height + 20, width: size.width - 40, height: (size.width - 40)*3/4)
                WordPicture.contentMode = UIViewContentMode.scaleAspectFit
                WordPicture.image = UIImage(data:imageDate as Data)
                WordPicture.tag = WordDetailViewController.LABEL_TAG
                
                let WordMean = UITextView()
                WordMean.text = selectDic.words[i].wordmean
                WordMean.font = UIFont(name: "Hiragino Sans", size: 15)
                WordMean.backgroundColor = .white
                WordMean.frame.size.width = size.width - 20
                WordMean.sizeToFit()
                WordMean.center = pageview.center
                WordMean.frame.origin.x = 10
                WordMean.frame.origin.y = WordName.frame.height + WordPicture.frame.height + 40
                WordMean.tag = WordDetailViewController.LABEL_TAG
                WordMean.isEditable = false
                WordMean.isScrollEnabled = false
                WordMean.isSelectable = false
                
                let pageviewscroll = UIScrollView()
                pageviewscroll.addSubview(WordName)
                pageviewscroll.addSubview(WordPicture)
                pageviewscroll.addSubview(WordMean)
                pageviewscroll.contentSize = CGSize(width: size.width, height: WordName.frame.size.height + WordMean.frame.size.height + WordPicture.frame.height + 100)
                pageviewscroll.contentOffset = CGPoint(x: 0, y: 0)
                pageviewscroll.frame = CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height + 100)
                
                contentView.addSubview(pageviewscroll)
                pageViewArray.append(pageviewscroll)
                
                
                /*
                if pageview.frame.size.height < WordName.frame.size.height + WordMean.frame.size.height + WordPicture.frame.height + 40{
                    WordMean.frame.size.height = pageview.frame.size.height - WordName.frame.size.height - WordPicture.frame.size.height + 100
                    WordMean.isScrollEnabled = true
                }else{
                    WordMean.isScrollEnabled = false
                }
                
                pageview.addSubview(WordName)
                pageview.addSubview(WordPicture)
                pageview.addSubview(WordMean)
                */

                

                
            } else {
                
                */
            /*
                let WordMean = UITextView()
                WordMean.text = selectDic.words[i].wordmean
                WordMean.font = UIFont(name: "Hiragino Sans", size: 15)
                WordMean.backgroundColor = .white
                WordMean.frame.size.width = size.width - 20
                WordMean.sizeToFit()
                WordMean.center = pageview.center
                WordMean.frame.origin.x = 10
                WordMean.frame.origin.y = WordName.frame.height + 20
                WordMean.tag = WordDetailViewController.LABEL_TAG
                WordMean.isEditable = false
                WordMean.isScrollEnabled = false
                WordMean.isSelectable = false
                
                let pageviewscroll = UIScrollView()
                pageviewscroll.addSubview(WordName)
                pageviewscroll.addSubview(WordMean)
                pageviewscroll.contentSize = CGSize(width: size.width, height: WordName.frame.size.height + WordMean.frame.size.height + 100)
                pageviewscroll.contentOffset = CGPoint(x: 0, y: 0)
                pageviewscroll.frame = CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height + 100)
                
                
                contentView.addSubview(pageviewscroll)
                pageViewArray.append(pageviewscroll)
            */


                /*
                if pageview.frame.size.height < WordName.frame.size.height + WordMean.frame.size.height + 20{
                    WordMean.frame.size.height = pageview.frame.size.height - WordName.frame.size.height + 100
                    WordMean.isScrollEnabled = true
                }else{
                    WordMean.isScrollEnabled = false
                }
 
 
                pageview.addSubview(WordName)
                pageview.addSubview(WordMean)
                */
            //}
            
            //contentView.addSubview(pageview)
            //pageViewArray.append(pageview)
 
        }
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        
        scrollView.contentOffset = CGPoint(x: ((size.width * CGFloat(selectrow))), y: 0)
        page =  Int((scrollView.contentOffset.x + (0.5 * scrollView.bounds.width)) / scrollView.bounds.width)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        //let clearbackimage = UIImage(named: "半透明2.png")
        let clearbackimage = UIImage(named: "halfclear")
        //let reSize = CGSize(width: (navigationController?.navigationBar.frame.size.width)!, height: (navigationController?.navigationBar.frame.size.height)!)
        //let clearbackimage = UIImage(named: "半透明2.png")?.reSizeImage(reSize: reSize)
        self.navigationController!.navigationBar.setBackgroundImage(clearbackimage, for: .default)
        self.navigationController!.navigationBar.shadowImage = clearbackimage
       // self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        //self.navigationController?.navigationBar.alpha = 0.5
        self.navigationController?.navigationBar.isTranslucent = true
 */

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController!.navigationBar.shadowImage = nil
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.alpha = 1.0
 */
    }
    @objc func tapped(_ sender: UITapGestureRecognizer){
       // print(navigationController?.navigationBar.barTintColor)
        if self.navigationController?.navigationBar.isHidden == true {
            //scrollView.frame.origin.y = scrollView.frame.origin.y - (navigationController?.navigationBar.frame.height)!
            navigationController?.setNavigationBarHidden(false, animated: true)

            //navigationController?.navigationBar.isTranslucent = false
        } else {
            //scrollView.frame.origin.y = scrollView.frame.origin.y + (navigationController?.navigationBar.frame.height)!
            
            navigationController?.setNavigationBarHidden(true, animated: true)

            //navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        page =  Int((scrollView.contentOffset.x + (0.5 * scrollView.bounds.width)) / scrollView.bounds.width)
        print(page)

    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func wordedit() {
        selectrow = page
        self.performSegue(withIdentifier: "toWordEdit", sender: self)
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toWordEdit") {
            let nc = segue.destination as! UINavigationController
            let WEVC = nc.topViewController as! WordEditViewController
            
            WEVC.dicid = self.dicid
           // WEVC.selectpicturekey = selectDic.words[page].wordpicturekey
            
            WEVC.selectpage = selectrow
            WEVC.selectDic = self.selectDic
            WEVC.userid = self.userid
        }
    }
    
    
 

}

extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
