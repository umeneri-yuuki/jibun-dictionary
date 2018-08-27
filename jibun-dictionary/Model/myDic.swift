//
//  myDic.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/25.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class myDic: NSObject, NSCoding{
    
    var dictitle: String!
    
    var words:[Word] = []
    
    func addWordList(word: Word,row: Int){
        self.words.append(word)
        
        self.save(row: row)
    }
    
    init(dictitle: String) {
        self.dictitle = dictitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dictitle = aDecoder.decodeObject(forKey: "dictitle") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        if let dictitle = dictitle { aCoder.encode(dictitle, forKey: "dictitle") }
    }
    
    func save(row: Int) {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: words),forKey: String(row))
        
    }
    
    func fetchWordList(row: Int){
        if let loadedData = UserDefaults().data(forKey: String(row)) {
            words = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as! [Word]
            print(words[words.count - 1].wordtitle)
        }
    }

    

}
