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
    
    init(dictitle: String) {
        self.dictitle = dictitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dictitle = aDecoder.decodeObject(forKey: "dictitle") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        if let dictitle = dictitle { aCoder.encode(dictitle, forKey: "dictitle") }
    }

    

}
