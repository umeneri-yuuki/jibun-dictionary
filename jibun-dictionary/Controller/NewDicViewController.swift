//
//  NewDicViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/26.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class NewDicViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var newDicname: UITextField!
    
    var mydiclist = DicList.sharedInstance
    //var mydiclist = DicList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDicViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        newDicname.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewDicViewController.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "作成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewDicViewController.save))
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        if newDicname.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "新規辞書名が記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else {
            let dic = myDic(dictitle: newDicname.text!)
            //dic.dictitle = newDicname.text!
            self.mydiclist.addDicList(dic: dic)
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        newDicname.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newDicname.resignFirstResponder()
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
