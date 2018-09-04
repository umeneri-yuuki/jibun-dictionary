//
//  WordDetailViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/30.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Totalのページ数
    var pageNum:Int!

    var screenSize:CGRect!
    
    
    var selectDic = myDic(dictitle: "",dicid: "")
    
    var dicid = -1
    
    var selectrow = -1
    
    static let LABEL_TAG = 100
    // 現在表示されているページ
    private var page: Int = 0
    // ScrollViewをスクロールする前の位置
    private var startPoint: CGPoint!
    // 表示するページビューの配列
    private var pageViewArray: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
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
        
        pageNum = selectDic.words.count
        
        for i in 0 ..< pageNum {
            //let page = makePage(x: CGFloat(i * Int(view.frame.width)), i: i)
            let pageview = UIView(frame: CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height))
            let WordName = UILabel()
            WordName.text = selectDic.words[i].wordtitle
            WordName.backgroundColor = .white
            WordName.sizeToFit()
            WordName.center = pageview.center
            WordName.frame.origin.x = 10
            WordName.tag = WordDetailViewController.LABEL_TAG
            
           
           // WordMean.isEditable = false
           // WordMean.text = selectDic.words[i].wordmean
            
            pageview.addSubview(WordName)
           // pageview.addSubview(WordMean)
            contentView.addSubview(pageview)
            pageViewArray.append(pageview)
        }
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        
        scrollView.contentOffset = CGPoint(x: ((size.width * CGFloat(selectrow))), y: 0)

    }
    
    /*
    func setPageView() {
        for i in 0..<pageViewArray.count {
            // ５つあるビューの真ん中が現在選択されているページになるようにする
            let index = getPageIndex(page: page + (i - 2))
            // tagからラベルを取得しtextを再設定
            let label: UILabel = pageViewArray[i].viewWithTag(WordDetailViewController.LABEL_TAG) as! UILabel
            label.text = selectDic.words[index].wordtitle
            label.sizeToFit()
        }
        
    }
    
    func getPageIndex(page: Int) -> Int {
        var index = page
        if index < 0 {
            index = (pageViewArray.count + page)
        } else if index >= pageViewArray.count {
            index = page - pageViewArray.count
        }
        return index
    }
 */
    /*
    func makePage(x: CGFloat ,i: Int)-> UIView{
        let pageview = UIView(frame: CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height))
        let WordName = UILabel()
        WordName.frame = CGRect(x: x + 16, y: 83, width: 343, height: 75)
        let WordMean = UITextView()
        WordMean.frame = CGRect(x: x + 16, y: 192, width: 343, height: 200)
        WordMean.isEditable = false
        
        WordName.text = selectDic.words[i].wordtitle
        WordMean.text = selectDic.words[i].wordmean
        
        pageview.addSubview(WordName)
        pageview.addSubview(WordMean)
        return pageview
    }
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
