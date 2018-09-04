//
//  DictionaryListViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/30.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class DictionaryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
    var mydiclist = DicList.sharedInstance
    
    var dicid = 0

    @IBOutlet weak var TableView: UITableView!
    
    //@IBOutlet weak var DLVtabbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        TableView.delegate = self
        TableView.dataSource = self

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        let diclisteditbutton :UIBarButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.tapDicListEdit))
        let diclistaddbutton :UIBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.newDic))
        self.navigationItem.setRightBarButtonItems([diclisteditbutton,diclistaddbutton], animated: true)
        //self.DLVtabbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        //self.DLVtabbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
       // self.navigationItem.leftBarButtonItem = editButtonItem
        self.TableView.reloadData()
        mydiclist.fetchDicList()
        tabBarController?.tabBar.isHidden = false
    }
    
    /*
    @IBAction func tapAddDic(_ sender: UIBarButtonItem) {
        self.newDic()
    }
 */
    
    @objc func newDic() {
        
        //self.dicid = self.mydiclist.dics.count
        let t = Int(Date().timeIntervalSince1970)
        self.dicid = t
        print("newid:\(self.dicid)")
        
        self.performSegue(withIdentifier: "toNewDic", sender: self)
    }
 

    @objc func tapDicListEdit(_ sender: UIBarButtonItem) {
        //編集モードにする
        self.TableView.setEditing(true, animated: true)
        //完了ボタンの追加
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DictionaryListViewController.done))
        
        
    }
    
    @objc func done() {
        //self.navigationItem.rightBarButtonItem?.isEnabled = false
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor(white: 0, alpha: 0)
        let diclisteditbutton :UIBarButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.tapDicListEdit))
        let diclistaddbutton :UIBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.newDic))
        self.navigationItem.setRightBarButtonItems([diclistaddbutton,diclisteditbutton], animated: true)
        //編集モードを終わる
        self.TableView.setEditing(false, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mydiclist.dics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let dic = self.mydiclist.dics[indexPath.row]
        cell.textLabel!.text = dic.dictitle
        cell.textLabel!.font = UIFont(name: "HirakakuProN-W3", size: 15)
        
        // Configure the cell...
        
        return cell
    }

    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        // self.selectDic = self.mydiclist.dics[indexPath.row]
        //self.selectDicNum = indexPath.row
        self.dicid = Int(self.mydiclist.dics[indexPath.row].dicid)!
        print("indexpath:\(indexPath.row)")
        print("id:\(self.dicid)")
        
        performSegue(withIdentifier: "toWordsList",sender:nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toWordsList") {
            let WLVC = segue.destination as! WordListViewController
            WLVC.dicid = self.dicid
            //WLVC.selectDic = self.selectDic
            //WLVC.selectDicNum = self.selectDicNum
        }
        
        if (segue.identifier == "toNewDic") {
            let nc = segue.destination as! UINavigationController
            let NDVC = nc.topViewController as! NewDicViewController
            NDVC.dicid = self.dicid
        }
 
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            UserDefaults.standard.removeObject(forKey: String(self.mydiclist.dics[indexPath.row].dicid)) 
            self.mydiclist.dics.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
            self.mydiclist.save()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let dic = self.mydiclist.dics[sourceIndexPath.row]
        self.mydiclist.dics.remove(at: sourceIndexPath.row)
        self.mydiclist.dics.insert(dic, at: destinationIndexPath.row)
        self.mydiclist.save()
        
    }

}
