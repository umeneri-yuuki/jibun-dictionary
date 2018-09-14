//
//  myDic.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/25.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class myDic: NSObject{
//, NSCoding{
    
    var dictitle: String!
    
    var dicid: String!
    
    var dicpos: Int!
    
    var words:[Word] = []
    
    func addWordList(word: Word){
        self.words.append(word)
        
       // self.save(row: row)
    }
    
    init(dictitle: String, dicid: String) {
        self.dictitle = dictitle
        self.dicid = dicid
    }
    /*
    required init?(coder aDecoder: NSCoder) {
        self.dictitle = aDecoder.decodeObject(forKey: "dictitle") as! String
        self.dicid = aDecoder.decodeObject(forKey: "dicid") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        if let dictitle = dictitle { aCoder.encode(dictitle, forKey: "dictitle") }
        if let dicid = dicid { aCoder.encode(dicid, forKey: "dicid") }
    }
    
    func save(row: Int) {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: words),forKey: String(row))
        
    }
    
    func fetchWordList(row: Int){
        if let loadedData = UserDefaults().data(forKey: String(row)) {
            words = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as! [Word]
            for title in words{
                print(title.wordtitle)
            }
           // print(words[words.count - 1].wordtitle)
        }
    }
*/
    

}
