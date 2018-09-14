//
//  DicList.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/25.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DicList: NSObject{
   static let sharedInstance = DicList()
   var dics:[myDic] = []
    var ref: DatabaseReference!

    func addDicList(dic: myDic){
        self.dics.append(dic)
    }
   
    /*
    func fetchDicList(){
        
        if let loadedData = UserDefaults().data(forKey: "dics") {
            dics = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as! [myDic]
        }
 
    
        ref = Database.database().reference()
        self.ref.child("users/dictionarylist").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for list in snapshot.children {
                
                let snap = list as! DataSnapshot
                let dic = snap.value as! [String: String]
                print((dic["dictitle"])!)
                print((dic["dicid"])!)// "category" keyの値がprintされる。
                self.selectdictitle = (dic["dictitle"])!
                self.dicid = (dic["dicid"])!
                //print("self.selectdictitle:\(self.selectdictitle)")
                //print("self.dicid:\(self.dicid)")
                //let newdic = myDic(dictitle: (dic["dictitle"])!, dicid: (dic["dicid"])!)
                //print(newdic.dictitle)
                // self.mydiclist.addDicList(dic: newdic)
                //print(self.mydiclist.dics[0].dictitle)
                let newdic = myDic(dictitle: self.selectdictitle, dicid: self.dicid)
                self.addDicList(dic: newdic)
            }
            
        }
        )
 
    }
 
    func save() {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: dics),forKey: "dics")
    }
 */
    
}
