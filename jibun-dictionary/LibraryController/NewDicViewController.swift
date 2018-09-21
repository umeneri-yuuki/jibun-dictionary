//
//  NewDicViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/26.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewDicViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var newDicname: UITextField!
    
    var ref: DatabaseReference!
    
    var mydiclist = DicList.sharedInstance
    
    var diccount = -1
    
    var userid = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDicViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        newDicname.delegate = self
        ref = Database.database().reference()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Clear"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewDicViewController.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Add"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewDicViewController.save))
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
           //let dicid = Int(Date().timeIntervalSince1970)
            let dicid = ref.child("user/\(self.userid)/dictionarylist").childByAutoId().key
            let dic = myDic(dictitle: newDicname.text!, dicid: dicid!)
            //dic.dicid = self.dicid
            //dic.dictitle = newDicname.text!
            self.mydiclist.addDicList(dic: dic)
           // self.mydiclist.save()
            newDicname.resignFirstResponder()
            
            //Firebase
            let dictitledata = ["dictitle": newDicname.text!]
            let diciddata = ["dicid": dicid!]
            let dicposdata = ["dicpos": diccount]
            
            let publishdata = ["publish": false]
            let useriddata = ["userid": self.userid]
            
            ref.child("user/\(self.userid)/dictionarylist/\(dicid!)").updateChildValues(dictitledata)
            ref.child("user/\(self.userid)/dictionarylist/\(dicid!)").updateChildValues(diciddata)
            ref.child("user/\(self.userid)/dictionarylist/\(dicid!)").updateChildValues(dicposdata)
            
            ref.child("alldictionarylist/\(dicid!)").updateChildValues(dictitledata)
            ref.child("alldictionarylist/\(dicid!)").updateChildValues(publishdata)
            ref.child("alldictionarylist/\(dicid!)").updateChildValues(useriddata)
            ref.child("alldictionarylist/\(dicid!)").updateChildValues(diciddata)

            
            
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
    
}
