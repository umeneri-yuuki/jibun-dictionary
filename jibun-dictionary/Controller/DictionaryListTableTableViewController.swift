//
//  DictionaryListTableTableViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/25.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class DictionaryListTableTableViewController: UITableViewController {
    
    var mydiclist = DicList.sharedInstance
    //var mydiclist = DicList()
    
   // var selectDic = myDic(dictitle: "")
    //var selectDicNum = 0
    var dicid = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        /*
        if let appDomain = Bundle.main.bundleIdentifier,
            let dic = UserDefaults.standard.persistentDomain(forName: appDomain) {
            
            for (key, value) in dic.sorted(by: { $0.0 < $1.0 }) {
                print("- \(key) => \(value)")
            }
        }
 */
        /*
        let userDefaults = UserDefaults.standard
        //全て消す
        if let domain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: domain)
        }
 */
 
 
       // self.mydiclist.sampleDic()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新規作成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DictionaryListTableTableViewController.newDic))
        self.navigationItem.leftBarButtonItem = editButtonItem
        self.tableView.reloadData()
        mydiclist.fetchDicList()
    }
    
    @objc func newDic() {
       
        //self.dicid = self.mydiclist.dics.count
        let t = Int(Date().timeIntervalSince1970)
        self.dicid = t
        print("newid:\(self.dicid)")
        
        self.performSegue(withIdentifier: "toNewDic", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //セクションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //Cellの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.mydiclist.dics.count
    }

    //Cellの中身
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let dic = self.mydiclist.dics[indexPath.row]
        cell.textLabel!.text = dic.dictitle
        cell.textLabel!.font = UIFont(name: "HirakakuProN-W3", size: 15)
        
        // Configure the cell...

        return cell
    }
    
    // Cell が選択された場合
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        
       // self.selectDic = self.mydiclist.dics[indexPath.row]
        //self.selectDicNum = indexPath.row
        self.dicid = Int(self.mydiclist.dics[indexPath.row].dicid)!
        print("indexpath:\(indexPath.row)")
        print("id:\(self.dicid)")
        
        performSegue(withIdentifier: "toWordsList",sender:nil)

    }
    
    // Segue 準備
    
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
 
    //editボタンを押したときのセルの操作
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.mydiclist.dics.remove(at: indexPath.row)
            self.mydiclist.save()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
        default:
            return
        }
    }
    
    //セルを移動する操作
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
           //let userDefaults = UserDefaults.standard
        
        /*
        if sourceIndexPath.row < destinationIndexPath.row {
            
            for row in sourceIndexPath.row + 1 ... destinationIndexPath.row {
                self.mydiclist.dics[row].save(row: row - 1)
            }
            self.mydiclist.dics[sourceIndexPath.row].save(row: sourceIndexPath.row)
        }else{
            self.mydiclist.dics[sourceIndexPath.row].save(row: destinationIndexPath.row)
            for row in destinationIndexPath.row ... sourceIndexPath.row - 1{
                self.mydiclist.dics[row].save(row: row + 1)
            }
  
        }
 */
        
      
        let dic = self.mydiclist.dics[sourceIndexPath.row]
        self.mydiclist.dics.remove(at: sourceIndexPath.row)
        self.mydiclist.dics.insert(dic, at: destinationIndexPath.row)
        self.mydiclist.save()
        
    }
    

 
 
 
 
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
