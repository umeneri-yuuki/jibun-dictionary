//
//  WordDetailViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/30.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController ,UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Totalのページ数
    var pageNum:Int!

    var screenSize:CGRect!
    
    
    var selectDic = myDic(dictitle: "",dicid: "")
    
    var dicid = -1
    
    var selectrow = -1
    
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
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectDic.fetchWordList(row: dicid)
        
         navigationController?.hidesBarsOnTap = true
        
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
            
            if let imageDate:NSData = UserDefaults.standard.object(forKey: selectDic.words[i].wordpicturekey) as? NSData {
                
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
                WordMean.isSelectable = true
                
                if pageview.frame.size.height < WordName.frame.size.height + WordMean.frame.size.height + WordPicture.frame.height + 40{
                    WordMean.frame.size.height = pageview.frame.size.height - WordName.frame.size.height - WordPicture.frame.size.height + 100
                    WordMean.isScrollEnabled = true
                }else{
                    WordMean.isScrollEnabled = false
                }
                
                pageview.addSubview(WordName)
                pageview.addSubview(WordPicture)
                pageview.addSubview(WordMean)
                
            } else {
                
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
                WordMean.isScrollEnabled = true
                WordMean.isSelectable = true

                if pageview.frame.size.height < WordName.frame.size.height + WordMean.frame.size.height + 20{
                    WordMean.frame.size.height = pageview.frame.size.height - WordName.frame.size.height + 100
                    WordMean.isScrollEnabled = true
                }else{
                    WordMean.isScrollEnabled = false
                }

                pageview.addSubview(WordName)
                pageview.addSubview(WordMean)
                
            }
            
            contentView.addSubview(pageview)
            pageViewArray.append(pageview)
 
        }
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        
        scrollView.contentOffset = CGPoint(x: ((size.width * CGFloat(selectrow))), y: 0)
        page =  Int((scrollView.contentOffset.x + (0.5 * scrollView.bounds.width)) / scrollView.bounds.width)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        page =  Int((scrollView.contentOffset.x + (0.5 * scrollView.bounds.width)) / scrollView.bounds.width)
        print(page)

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
            WEVC.selectpage = self.page
            WEVC.selectpicturekey = selectDic.words[page].wordpicturekey
        }
    }
    
    
 

}
