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
    
    var selectdictitle = ""
    
    var selectdicnum = 0
    
    var renametext = ""

    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        TableView.delegate = self
        TableView.dataSource = self
        
        mydiclist.fetchDicList()
        
         //userdefaultのデータを全部消す処理
        //let appDomain = Bundle.main.bundleIdentifier
        //UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.isTranslucent = false
        
        let diclisteditbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EditItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.tapDicListEdit))
        
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        self.navigationItem.setRightBarButtonItems([diclisteditbutton], animated: true)
        self.navigationItem.setLeftBarButtonItems([flexibleItem], animated: true)
        self.TableView.reloadData()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func newDic() {
        self.done()
        /*
        let t = Int(Date().timeIntervalSince1970)
        self.dicid = t
 */
        self.performSegue(withIdentifier: "toNewDic", sender: self)
    }
 

    @objc func tapDicListEdit(_ sender: UIBarButtonItem) {
        //編集モードにする
        self.TableView.setEditing(true, animated: true)
        //完了ボタンの追加
          let diclistaddbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.newDic))
        let diclistfinishbutton = UIBarButtonItem(image: UIImage(named: "FinishItem"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(DictionaryListViewController.done))
        
         self.navigationItem.setRightBarButtonItems([diclistfinishbutton], animated: true)
         self.navigationItem.setLeftBarButtonItems([diclistaddbutton], animated: true)
        
        
    }
    
    @objc func done() {
        let diclisteditbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EditItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.tapDicListEdit))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        self.navigationItem.setRightBarButtonItems([diclisteditbutton], animated: true)
        self.navigationItem.setLeftBarButtonItems([flexibleItem], animated: true)
        //編集モードを終わる
        self.TableView.setEditing(false, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mydiclist.dics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let dic = self.mydiclist.dics[indexPath.row]
        cell.textLabel!.text = dic.dictitle
        cell.textLabel!.font = UIFont(name: "HirakakuProN-W3", size: 15)
        
        return cell
    }

    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        //self.selectdictitle = self.mydiclist.dics[indexPath.row].dictitle
        //self.dicid = Int(self.mydiclist.dics[indexPath.row].dicid)!
        self.selectdicnum = indexPath.row
        performSegue(withIdentifier: "toWordsList",sender:nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toWordsList") {
            let WLVC = segue.destination as! WordListViewController
            //WLVC.dicid = self.dicid
            //WLVC.selectdictitle = self.selectdictitle
            WLVC.selectDic = mydiclist.dics[selectdicnum]
        }
        /*
        if (segue.identifier == "toNewDic") {
            let nc = segue.destination as! UINavigationController
            let NDVC = nc.topViewController as! NewDicViewController
            //NDVC.dicid = self.dicid
        }
        */
 
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            for word in self.mydiclist.dics[indexPath.row].words {
                UserDefaults.standard.removeObject(forKey: word.wordpicturekey)
            }
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
