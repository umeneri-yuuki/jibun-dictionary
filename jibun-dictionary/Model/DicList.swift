//
//  DicList.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/25.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class DicList: NSObject {
    
   var dics:[myDic] = []
    
  func sampleDic() {
        for i in 0..<3 {
            let dic = myDic()
            let word = Word()
            word.wordtitle = "辞書\(i + 1)"
            dic.words.append(word)
            dic.dictitle = "辞書\(i + 1)"
            self.dics.append(dic)
        }
    }

}
