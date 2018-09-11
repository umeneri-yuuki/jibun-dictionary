//
//  DicList.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/25.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class DicList: NSObject{
   static let sharedInstance = DicList()
   var dics:[myDic] = []
    
    func addDicList(dic: myDic){
        self.dics.append(dic)
    }
   
    
    func fetchDicList(){
        if let loadedData = UserDefaults().data(forKey: "dics") {
            dics = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as! [myDic]
        }
    }
 
    func save() {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: dics),forKey: "dics")
    }
    
}
