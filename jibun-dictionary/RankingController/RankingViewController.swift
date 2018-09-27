//
//  RankingViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/21.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RankingViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var TableView: UITableView!
    
    var rankingdiclist = DicList()
    
    var ref: DatabaseReference!
    
    var refreshControl:UIRefreshControl!
    
    var userid = ""
    var username = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.delegate = self
        TableView.dataSource = self
        
        ref = Database.database().reference()
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        self.TableView.addSubview(refreshControl)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        let user = Auth.auth().currentUser
        if let user = user {
            self.userid = user.uid
            self.username = user.displayName!
        }
 */
        
        
        self.ref.child("alldictionarylist").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let diclist = DicList()
            
            for list in snapshot.children {
                
                let snap = list as! DataSnapshot
                let dic = snap.value as! [String: Any]
                let selectdictitle = (dic["dictitle"])! as! String
                let selectdicpublish = (dic["publish"])! as! Bool
                if selectdicpublish == true {
                let newdic = myDic(dictitle: selectdictitle, dicid: "")
                diclist.addDicList(dic: newdic)
                }
                
            }
            self.rankingdiclist.dics  = diclist.dics
            //self.rankingdiclist.dics  = diclist.dics.sorted(by: {$0.dicpos < $1.dicpos})
            
            self.TableView.reloadData()
            
        }
        )
        
        self.TableView.reloadData()
        
        
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        self.ref.child("alldictionarylist").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let diclist = DicList()
            
            for list in snapshot.children {
                
                let snap = list as! DataSnapshot
                let dic = snap.value as! [String: Any]
                let selectdictitle = (dic["dictitle"])! as! String
                let selectdicpublish = (dic["publish"])! as! Bool
                if selectdicpublish == true {
                    let newdic = myDic(dictitle: selectdictitle, dicid: "")
                    diclist.addDicList(dic: newdic)
                }
                
            }
            self.rankingdiclist.dics  = diclist.dics
            //self.rankingdiclist.dics  = diclist.dics.sorted(by: {$0.dicpos < $1.dicpos})
            
            self.TableView.reloadData()
            
        }
        )
        
        self.TableView.reloadData()
        
        sender.endRefreshing()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankingdiclist.dics.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        //let button = cell.viewWithTag(1) as! UIButton
        
        let dic = self.rankingdiclist.dics[indexPath.row]
        cell.textLabel!.text = dic.dictitle
        cell.textLabel!.font = UIFont(name: "HirakakuProN-W3", size: 15)
        
        
        
        return cell
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
