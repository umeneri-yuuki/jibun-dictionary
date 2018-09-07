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
    
    var renametext = ""

    @IBOutlet weak var TableView: UITableView!
    
    //@IBOutlet weak var DLVtabbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        TableView.delegate = self
        TableView.dataSource = self

        // Do any additional setup after loading the view.
        /*
         //userdefaultのデータを全部消す処理
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
 */
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.isTranslucent = false
        //self.tabBarController!.tabBar.isTranslucent = false
        
        /*
        let editbutton: UIButton = UIButton.init()
        editbutton.setImage(UIImage.init(named: "EditItem"), for: .normal)
        editbutton.sizeToFit()
  
        let diclisteditbutton = UIBarButtonItem.init(customView: editbutton)
        */
       let diclisteditbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EditItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.tapDicListEdit))
        
    
 
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        /*
        let addbutton: UIButton = UIButton.init()
        addbutton.setImage(UIImage.init(named: "AddItem"), for: .normal)
        addbutton.sizeToFit()
        addbutton.target(forAction: #selector(DictionaryListViewController.newDic), withSender: self)
        
        let diclistaddbutton = UIBarButtonItem.init(customView: addbutton)
*/
 
        //let diclistaddbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.newDic))
        self.navigationItem.setRightBarButtonItems([diclisteditbutton], animated: true)
        self.navigationItem.setLeftBarButtonItems([flexibleItem], animated: true)
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
        
        self.done()
        
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
          let diclistaddbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.newDic))
        let diclistfinishbutton = UIBarButtonItem(image: UIImage(named: "FinishItem"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(DictionaryListViewController.done))
        
         self.navigationItem.setRightBarButtonItems([diclistaddbutton], animated: true)
         self.navigationItem.setLeftBarButtonItems([diclistfinishbutton], animated: true)
        
        
    }
    
    @objc func done() {
        //self.navigationItem.rightBarButtonItem?.isEnabled = false
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor(white: 0, alpha: 0)
        let diclisteditbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EditItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.tapDicListEdit))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        //let diclistaddbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.newDic))

        self.navigationItem.setRightBarButtonItems([diclisteditbutton], animated: true)
        self.navigationItem.setLeftBarButtonItems([flexibleItem], animated: true)
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
        
         self.selectdictitle = self.mydiclist.dics[indexPath.row].dictitle
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
            WLVC.selectdictitle = self.selectdictitle
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
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete"){ action, indexPath in
            for word in self.mydiclist.dics[indexPath.row].words {
                UserDefaults.standard.removeObject(forKey: word.wordpicturekey)
            }
            UserDefaults.standard.removeObject(forKey: String(self.mydiclist.dics[indexPath.row].dicid))
            self.mydiclist.dics.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
            self.mydiclist.save()
        }
        
        let rename = UITableViewRowAction(style: .default, title: "Rename"){ action, indexPath in
            
            let alert:UIAlertController = UIAlertController(title: "辞書名の変更", message: "新しい名前を入力してください", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { action in
                print("Hello World!!")
                self.mydiclist.dics[indexPath.row].dictitle = self.renametext
                self.mydiclist.save()
                self.TableView.reloadData()
            }
            
            alert.addTextField{ (textField: UITextField!) -> Void in
               
                let Notification = NotificationCenter.default
                
                Notification.addObserver(self, selector: #selector(self.Rename(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        rename.backgroundColor = UIColor.gray
        
        return [rename,delete]
    }
    
    @objc func Rename(sender: NSNotification) {

        let textField = sender.object as! UITextField

        self.renametext = textField.text!
        
    }
 */

}
