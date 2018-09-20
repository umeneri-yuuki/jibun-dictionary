//
//  DictionaryListViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/30.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

//import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class DictionaryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
    var mydiclist = DicList.sharedInstance
    
    var dicid = ""
    
    var selectdictitle = ""
    
    var selectdicpos = 0
    
    var selectdicnum = 0
    
    var renametext = ""
    
    var ref: DatabaseReference!
    var storage = Storage.storage()
    var auth: Auth!
    var handle: AuthStateDidChangeListenerHandle?
    
    var userid = ""
    var username = ""

    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        TableView.delegate = self
        TableView.dataSource = self
        
        ref = Database.database().reference()
        
        self.auth = Auth.auth()
        
        
        
        
 
        /*
            self.ref?.child("users/dictionarylist").observe(.childAdded, with: { [weak self](snapshot) -> Void in
                self?.selectdictitle = String(describing: snapshot.childSnapshot(forPath: "dictitle").value!)
                self?.dicid = String(describing: snapshot.childSnapshot(forPath: "dicid").value!)
                
                // ここでtableviewなどの更新を行う
                
                //self?.finishReceivingMessage()
            })
 */
        

        

       // print(newdic.dictitle)

        //print(self.mydiclist.dics[0].dictitle)
         //userdefaultのデータを全部消す処理
        //let appDomain = Bundle.main.bundleIdentifier
       // UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.handle = self.auth.addStateDidChangeListener { (auth, user) in
        }
        
        let user = Auth.auth().currentUser
        if let user = user {
            self.userid = user.uid
            self.username = user.displayName!
            
        }
        
        print("userid:\(self.userid)")
        print("username:\(self.username)")
        
      
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.isTranslucent = false
        
        let diclisteditbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EditItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(DictionaryListViewController.tapDicListEdit))
        
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        self.navigationItem.setRightBarButtonItems([diclisteditbutton], animated: true)
        self.navigationItem.setLeftBarButtonItems([flexibleItem], animated: true)
        
        self.ref.child("\(self.userid)/dictionarylist").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let diclist = DicList()
            
            for list in snapshot.children {
                
                let snap = list as! DataSnapshot
                let dic = snap.value as! [String: Any]
                print((dic["dictitle"])!)
                print((dic["dicid"])!)// "category" keyの値がprintされる。
                self.selectdictitle = (dic["dictitle"])! as! String
                self.dicid = (dic["dicid"])! as! String
                self.selectdicpos = (dic["dicpos"])! as! Int
                print("self.selectdictitle:\(self.selectdictitle)")
                print("self.dicid:\(self.dicid)")
                //let newdic = myDic(dictitle: (dic["dictitle"])!, dicid: (dic["dicid"])!)
                //print(newdic.dictitle)
                // self.mydiclist.addDicList(dic: newdic)
                //print(self.mydiclist.dics[0].dictitle)
                let newdic = myDic(dictitle: self.selectdictitle, dicid: self.dicid)
                newdic.dicpos = self.selectdicpos
                diclist.addDicList(dic: newdic)
                
            }
            
            self.mydiclist.dics  = diclist.dics.sorted(by: {$0.dicpos < $1.dicpos})
            
            self.TableView.reloadData()
            
        }
        )
        
        self.TableView.reloadData()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.auth.removeStateDidChangeListener(self.handle!)
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
        self.selectdictitle = self.mydiclist.dics[indexPath.row].dictitle
        //self.dicid = Int(self.mydiclist.dics[indexPath.row].dicid)!
        self.selectdicnum = indexPath.row
        performSegue(withIdentifier: "toWordsList",sender:nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toWordsList") {
            let WLVC = segue.destination as! WordListViewController
            WLVC.dicid = mydiclist.dics[selectdicnum].dicid
            WLVC.selectdictitle = self.selectdictitle
            WLVC.userid = self.userid
            //WLVC.selectDic = mydiclist.dics[selectdicnum]
        }
        
        if (segue.identifier == "toNewDic") {
            let nc = segue.destination as! UINavigationController
            let NDVC = nc.topViewController as! NewDicViewController
            NDVC.diccount = self.mydiclist.dics.count
            NDVC.userid = self.userid
        }
        
 
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            /*
            for word in self.mydiclist.dics[indexPath.row].words {
                UserDefaults.standard.removeObject(forKey: word.wordpicturekey)
            }
            UserDefaults.standard.removeObject(forKey: String(self.mydiclist.dics[indexPath.row].dicid))
             */
            self.mydiclist.dics.remove(at: indexPath.row)
            
            self.ref.child("\(self.userid)/dictionarylist").observeSingleEvent(of: .value, with: { (snapshot) in
                
                for list in snapshot.children {
                    
                    let snap = list as! DataSnapshot
                    let dic = snap.value as! [String: Any]
                    self.selectdictitle = (dic["dictitle"])! as! String
                    self.dicid = (dic["dicid"])! as! String
                    self.selectdicpos = (dic["dicpos"])! as! Int
                    if indexPath.row == self.selectdicpos {
                        self.ref.child("\(self.userid)/dictionarylist/\(self.dicid)").removeValue()
                        let storageRef = self.storage.reference()
                        let reference = storageRef.child("\(self.userid)/dictionarylist/\(self.dicid)")
                        reference.delete { error in
                            if error != nil {
                                // Uh-oh, an error occurred!
                            } else {
                                // File deleted successfully
                            }
                        }
                    }
                    if indexPath.row < self.selectdicpos {
                        let data = ["dicpos":self.selectdicpos - 1]
                        self.ref.child("\(self.userid)/dictionarylist/\(self.dicid)").updateChildValues(data)
                    }
                }
            }
            )
            
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
            //self.mydiclist.save()

        default:
            return
        }
    }
 
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let dic = self.mydiclist.dics[sourceIndexPath.row]
        self.mydiclist.dics.remove(at: sourceIndexPath.row)
        self.mydiclist.dics.insert(dic, at: destinationIndexPath.row)
       // self.mydiclist.save()
        var counter = 0
        for dic in self.mydiclist.dics{
            let data = ["dicpos":counter]
             ref.child("\(self.userid)/dictionarylist/\(dic.dicid!)").updateChildValues(data)
            counter = counter + 1
        }
        
    }
   
}
