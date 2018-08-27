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
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: dics),forKey: "dics")
        //self.save()
       // let adddic = myDic(dictitle: dic.dictitle)
    }
   
    
    func fetchDicList(){
        if let loadedData = UserDefaults().data(forKey: "dics") {
            dics = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as! [myDic]
        }
    }
 
    
   // func save() {
    //}
    
    
/*
  func sampleDic() {
        for i in 0..<3 {
            let dic = myDic()
            let word1 = Word()
            word1.wordtitle = "ワード\(i + 1)"
            dic.words.append(word1)
            let word2 = Word()
            word2.wordtitle = "ワード\(i + 2)"
            dic.words.append(word2)
            let word3 = Word()
            word3.wordtitle = "ワード\(i + 3)"
            dic.words.append(word3)
            dic.dictitle = "辞書\(i + 1)"
            self.dics.append(dic)
        }
    }
    */

}
