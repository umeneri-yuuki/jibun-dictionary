//
//  Word.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/25.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class Word: NSObject, NSCoding{
    
    var wordtitle: String!
    var wordmean: String!
    
    init(wordtitle: String, wordmean: String) {
        self.wordtitle = wordtitle
        self.wordmean = wordmean
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.wordtitle = aDecoder.decodeObject(forKey: "wordtitle") as! String
        self.wordmean = aDecoder.decodeObject(forKey: "wordmean") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        if let wordtitle = wordtitle { aCoder.encode(wordtitle, forKey: "wordtitle") }
        if let wordmean = wordmean { aCoder.encode(wordmean, forKey: "wordmean") }
    }

}
