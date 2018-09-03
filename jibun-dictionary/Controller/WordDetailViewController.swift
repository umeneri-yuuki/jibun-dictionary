//
//  WordDetailViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/30.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController {
    @IBOutlet weak var WordName: UILabel!
    
    @IBOutlet weak var WordMean: UITextView!
    
    var selectDic = myDic(dictitle: "",dicid: "")
    
    var dicid = -1
    
    var selectrow = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectDic.fetchWordList(row: dicid)
        WordName.text = selectDic.words[selectrow].wordtitle
        WordMean.text = selectDic.words[selectrow].wordmean
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
