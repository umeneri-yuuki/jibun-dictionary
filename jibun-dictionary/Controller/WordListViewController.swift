//
//  WordListViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class WordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    var selectDic = myDic(dictitle: "",dicid: "")
    //var selectDicNum = 0
    var dicid = -1
    
    var selectrow = -1

    @IBOutlet weak var TableView: UITableView!
    
    
    //@IBOutlet weak var WLVtabbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(selectDic.dictitle)
        //print(selectDicNum)
       // print(selectDic.words[0])
        print(dicid)

        // Do any additional setup after loading the view.
        TableView.delegate = self
        TableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black

        let wordlisteditbutton :UIBarButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItemStyle.plain, target: self, action:#selector(WordListViewController.tapWordEdit))
        let wordlistaddbutton :UIBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.plain, target: self, action:#selector(WordListViewController.newWord))
        self.navigationItem.setRightBarButtonItems([wordlistaddbutton,wordlisteditbutton], animated: true)
       // self.WLVtabbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        //self.WLVtabbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        self.TableView.reloadData()
        selectDic.fetchWordList(row: dicid)
        self.navigationItem.title = selectDic.dictitle
        
    }
    /*
    @objc func tapAddWord(_ sender: UIBarButtonItem) {
        self.newWord()
    }
 */
    
    @objc func newWord() {
        self.performSegue(withIdentifier: "toNewWord", sender: self)
    }
    @objc func tapWordEdit(_ sender: UIBarButtonItem) {
        //編集モードにする
        self.TableView.setEditing(true, animated: true)
        //完了ボタンの追加
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WordListViewController.done))
        
    }
    
    
    @objc func done() {
        //self.navigationItem.rightBarButtonItem?.isEnabled = false
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor(white: 0, alpha: 0)
        let wordlisteditbutton :UIBarButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItemStyle.plain, target: self, action:#selector(WordListViewController.tapWordEdit))
        let wordlistaddbutton :UIBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.plain, target: self, action:#selector(WordListViewController.newWord))
        self.navigationItem.setRightBarButtonItems([wordlistaddbutton,wordlisteditbutton], animated: true)
        //編集モードを終わる
        self.TableView.setEditing(false, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toNewWord") {
            let nc = segue.destination as! UINavigationController
            let NWVC = nc.topViewController as! NewWordViewController
            NWVC.selectDic = self.selectDic
            NWVC.dicid = self.dicid
        }
        if (segue.identifier == "toWordDetail") {
            let WDVC = segue.destination as! WordDetailViewController
            WDVC.dicid = self.dicid
            WDVC.selectrow = self.selectrow
            //WLVC.selectDic = self.selectDic
            //WLVC.selectDicNum = self.selectDicNum
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectDic.words.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let word = self.selectDic.words[indexPath.row]
        cell.textLabel!.text = word.wordtitle
        cell.textLabel!.font = UIFont(name: "HirakakuProN-W3", size: 15)
        
        return cell
    }
    
    //編集中のセルの操作
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.selectDic.words.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
            if self.selectDic.words.isEmpty == false {
            self.selectDic.save(row: dicid)
            } else {
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: String(dicid))
            }
        default:
            return
        }
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        // self.selectDic = self.mydiclist.dics[indexPath.row]
        self.selectrow = indexPath.row
        // self.dicid = Int(self.selectDic.dicid)!
        //print("indexpath:\(indexPath.row)")
        //print("id:\(self.dicid)")
        
        performSegue(withIdentifier: "toWordDetail",sender:nil)
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let dic = self.selectDic.words[sourceIndexPath.row]
        self.selectDic.words.remove(at: sourceIndexPath.row)
        self.selectDic.words.insert(dic, at: destinationIndexPath.row)
        self.selectDic.save(row: dicid)
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
