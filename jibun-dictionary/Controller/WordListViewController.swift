//
//  WordListViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class WordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
   
    var mydiclist = DicList.sharedInstance
    
    var selectDic = myDic(dictitle: "",dicid: "")

    var dicid = -1
    
    var selectrow = -1
    
    var selectdictitle = ""
    
    var tableheight = CGFloat()
    
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var WordListTitle: UINavigationItem!
    @IBOutlet weak var editview: UIView!
    
    @IBOutlet weak var renameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)

        TableView.delegate = self
        TableView.dataSource = self
        tabBarController?.tabBar.isHidden = true
        renameTextField.delegate = self
        
        editview.isHidden = true
        
        self.navigationItem.leftItemsSupplementBackButton = true
        
        selectDic.fetchWordList(row: Int(selectDic.dicid)!)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController!.navigationBar.backgroundColor = UIColor.white
        //self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
       // self.navigationController!.navigationBar.shadowImage = nil
       // navigationController?.navigationBar.alpha = 1.0
        //self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.black

        let wordlisteditbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EditItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(WordListViewController.tapWordEdit))
        self.navigationItem.setRightBarButtonItems([wordlisteditbutton], animated: true)

        let wordlistaddbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(WordListViewController.newWord))
        self.navigationItem.setLeftBarButtonItems([wordlistaddbutton], animated: true)
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.tintColor =  UIColor.clear
        
        self.TableView.reloadData()

        //selectDic.dictitle = selectdictitle
        
        self.WordListTitle.title = selectDic.dictitle
        print("選択した辞書の名前：\(selectDic.dictitle)")
       
        navigationController?.hidesBarsOnTap = false
        
        tableheight = TableView.frame.size.height
        
    }
    
    @objc func newWord() {
        self.done()
        //self.doneprocess()
        self.performSegue(withIdentifier: "toNewWord", sender: self)
    }
    @objc func tapWordEdit(_ sender: UIBarButtonItem) {
        self.navigationItem.leftItemsSupplementBackButton = false
        TableView.translatesAutoresizingMaskIntoConstraints = true
        TableView.frame = CGRect(x: 0, y: editview.frame.size.height, width: TableView.frame.size.width, height: tableheight - editview.frame.size.height)
        editview.isHidden = false
        //編集モードにする
        self.TableView.setEditing(true, animated: true)
        //完了ボタンの追加
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.tintColor =  UIColor.black

        let wordlistfinishbutton = UIBarButtonItem(image: UIImage(named: "FinishItem"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WordListViewController.done))
        self.navigationItem.setRightBarButtonItems([wordlistfinishbutton], animated: true)
        
        self.renameTextField.text = selectDic.dictitle
        self.WordListTitle.title = ""
        
    }
    
    /*
    @objc func doneprocess() {
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

        print("にゃー")

        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
     
    }
 */
    
    @objc func done() {
        self.navigationItem.leftItemsSupplementBackButton = true
        TableView.frame = CGRect(x: 0, y:0, width: TableView.frame.size.width, height: tableheight)
        TableView.translatesAutoresizingMaskIntoConstraints = false
        editview.isHidden = true
        
        let wordlisteditbutton :UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EditItem"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(WordListViewController.tapWordEdit))
        
        self.navigationItem.setRightBarButtonItems([wordlisteditbutton], animated: true)
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.tintColor =  UIColor.clear
        
        selectDic.dictitle = self.renameTextField.text
        self.WordListTitle.title = selectDic.dictitle
        
        self.TableView.setEditing(false, animated: true)
        editview.endEditing(true)
        
        self.selectDic.save(row: Int(selectDic.dicid)!)
        
        for dic in mydiclist.dics {
            if dic.dicid == selectDic.dicid {
                dic.dictitle = selectDic.dictitle
            }
        }
        

        print("にゃー")
    }
    
    @objc func tappedLeftBarButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toNewWord") {
            let nc = segue.destination as! UINavigationController
            let NWVC = nc.topViewController as! NewWordViewController
            NWVC.selectDic = self.selectDic
            //NWVC.dicid = self.dicid
        }
        if (segue.identifier == "toWordDetail") {
            let WDVC = segue.destination as! WordDetailViewController
            WDVC.selectDic = self.selectDic
            
            WDVC.selectrow = self.selectrow
            /*
            WDVC.dicid = self.dicid
             */
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
            UserDefaults.standard.removeObject(forKey: selectDic.words[indexPath.row].wordpicturekey)
            self.selectDic.words.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)

            if self.selectDic.words.isEmpty == false {
            self.selectDic.save(row: Int(selectDic.dicid)!)
            } else {
                UserDefaults.standard.removeObject(forKey: selectDic.dicid)
            }
        default:
            return
        }
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        

        self.selectrow = indexPath.row
        
        performSegue(withIdentifier: "toWordDetail",sender:nil)
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let dic = self.selectDic.words[sourceIndexPath.row]
        self.selectDic.words.remove(at: sourceIndexPath.row)
        self.selectDic.words.insert(dic, at: destinationIndexPath.row)
        self.selectDic.save(row: Int(selectDic.dicid)!)
    }
    
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        editview.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editview.endEditing(true)
        return true
    }

}
