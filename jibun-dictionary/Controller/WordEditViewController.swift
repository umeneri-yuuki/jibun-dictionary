//
//  WordEditViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/08.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class WordEditViewController: UIViewController {
    
    
    @IBOutlet weak var edittextfield: UITextField!
    @IBOutlet weak var editimageview: UIImageView!
    @IBOutlet weak var edittextview: UITextView!
    
    var selectDic = myDic(dictitle: "",dicid: "")
    var dicid = -1
    var selectpage = -1
    var selectpicturekey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectDic.fetchWordList(row: dicid)
        print("編集するページは\(selectpage)")
        edittextfield.text = selectDic.words[selectpage].wordtitle
        edittextview.text = selectDic.words[selectpage].wordmean
        
        if let imageDate:NSData = UserDefaults.standard.object(forKey: selectpicturekey) as? NSData {
            editimageview.image = UIImage(data:imageDate as Data)
        }
        
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Clear"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WordEditViewController.close))
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
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
