//
//  NewWordViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class NewWordViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var newWordtitle: UITextField!
    @IBOutlet weak var newWordmean: UITextView!
    
    var selectDic = myDic(dictitle: "",dicid: "")
    var selectDicNum = 0
    var dicid = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectDic.dictitle)
        print(dicid)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewWordViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        newWordtitle.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewWordViewController.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewWordViewController.save))
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        if newWordtitle.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "単語名が記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else {
            let word = Word(wordtitle: newWordtitle.text!, wordmean: newWordmean.text!)
            self.selectDic.addWordList(word: word, row: self.dicid)
            print(selectDic.words[selectDic.words.count - 1].wordtitle)
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        newWordtitle.resignFirstResponder()
        newWordmean.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newWordtitle.resignFirstResponder()
        return true
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
