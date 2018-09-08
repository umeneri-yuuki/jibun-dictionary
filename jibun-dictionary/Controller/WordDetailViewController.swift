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
        
        // navigationController?.hidesBarsOnTap = true
        
        //　scrollViewの表示サイズ
        let size = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        // 5ページ分のcontentSize
        let contentRect = CGRect(x: 0, y: 0, width: size.width * CGFloat(selectDic.words.count), height: size.height)
        let contentView = UIView(frame: contentRect)
        
        let wordeditbutton :UIBarButtonItem = UIBarButtonItem(title: "単語編集", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.wordedit))
        self.navigationItem.setRightBarButtonItems([wordeditbutton], animated: true)
        
        pageNum = selectDic.words.count
        
        for i in 0 ..< pageNum {
            //let page = makePage(x: CGFloat(i * Int(view.frame.width)), i: i)
            let pageview = UIView(frame: CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height))
            let WordName = UILabel()
            WordName.text = selectDic.words[i].wordtitle
            WordName.backgroundColor = .white
            WordName.sizeToFit()
            WordName.center = pageview.center
            WordName.frame.origin.x = 20
            WordName.frame.origin.y = 20
            WordName.tag = WordDetailViewController.LABEL_TAG
            
            //let imageDate:NSData = UserDefaults.standard.object(forKey: selectDic.words[i].wordpicturekey) as! NSData
            //if UIImage(data:imageDate as Data) != UIImage(named: "noImage.png"){
            
            if let imageDate:NSData = UserDefaults.standard.object(forKey: selectDic.words[i].wordpicturekey) as? NSData {
                
                let WordPicture = UIImageView()
                WordPicture.frame = CGRect(x: 20, y: WordName.frame.height + 20, width: size.width - 40, height: (size.width - 40)*3/4)
                WordPicture.contentMode = UIViewContentMode.scaleAspectFit
                WordPicture.image = UIImage(data:imageDate as Data)
                WordPicture.tag = WordDetailViewController.LABEL_TAG
                
                
                let WordMean = UITextView()
                WordMean.text = selectDic.words[i].wordmean
                WordMean.backgroundColor = .white
                WordMean.sizeToFit()
                WordMean.center = pageview.center
                WordMean.frame.origin.x = 20
                WordMean.frame.origin.y = WordName.frame.height + WordPicture.frame.height + 40
                WordMean.tag = WordDetailViewController.LABEL_TAG
                WordMean.isEditable = false
                
                pageview.addSubview(WordName)
                pageview.addSubview(WordPicture)
                pageview.addSubview(WordMean)
                
            } else {
                
                let WordMean = UITextView()
                WordMean.text = selectDic.words[i].wordmean
                WordMean.backgroundColor = .white
                WordMean.sizeToFit()
                WordMean.center = pageview.center
                WordMean.frame.origin.x = 20
                WordMean.frame.origin.y = WordName.frame.height + 20
                WordMean.tag = WordDetailViewController.LABEL_TAG
                WordMean.isEditable = false
                
                pageview.addSubview(WordName)
                pageview.addSubview(WordMean)
                
            }
            
            contentView.addSubview(pageview)
            pageViewArray.append(pageview)
        }
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        
        scrollView.contentOffset = CGPoint(x: ((size.width * CGFloat(selectrow))), y: 0)

    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        page =  Int((scrollView.contentOffset.x + (0.5 * scrollView.bounds.width)) / scrollView.bounds.width)
        print(page)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func wordedit() {
        self.performSegue(withIdentifier: "toWordEdit", sender: self)
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
