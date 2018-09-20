//
//  AcountEditViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/20.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseAuth

class AcountEditViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    

    let editsection = ["","","",""]

    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        TableView.delegate = self
        TableView.dataSource = self
        // Do any additional setup after loading the view.
        
        tabBarController?.tabBar.isHidden = true
        
       // TableView.register(UITableViewCell.self, forCellReuseIdentifier: "mycell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return editsection.count
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return editsection[section]

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        }else if section == 2 {
            return 1
        }else if section == 3 {
            return 1
        }else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "アカウント名の設定"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "メールアドレスの設定"
        }else if indexPath.section == 2 {
            cell.textLabel?.text = "パスワードの設定"
        }else if indexPath.section == 3 {
            cell.textLabel?.text = "ログアウト"
            cell.textLabel?.textColor = UIColor.red
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
       
            headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "toNameEdit",sender:nil)
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: "toEmailEdit",sender:nil)
        } else if indexPath.section == 2 {
            performSegue(withIdentifier: "toPasswordEdit",sender:nil)
        }else if indexPath.section == 3 {
            let alertView = UIAlertController(title: "ログアウト", message: "ログアウトしますか", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "toFirstView",sender:nil)
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: nil)
            alertView.addAction(OKAction)
            alertView.addAction(cancelAction)
            
            self.present(alertView, animated: true, completion: nil)

            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // ヘッダーViewの高さを返す
        return 40
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
