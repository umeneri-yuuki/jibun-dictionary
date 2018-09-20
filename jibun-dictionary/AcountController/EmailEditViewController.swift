//
//  EmailEditViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/20.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailEditViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var TableView: UITableView!
    
    var currentEmail: UITextField!
    var newEmail: UITextField!
    var newEmailRe: UITextField!
    
    var AcountEmail = ""
    var newAcountEmail = ""
    
    var auth: Auth!
    var handle: AuthStateDidChangeListenerHandle?
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        
        self.auth = Auth.auth()
        
        if let user = user {
            AcountEmail = user.email!
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.handle = self.auth.addStateDidChangeListener { (auth, user) in
        }
        
        let editfinishbutton :UIBarButtonItem = UIBarButtonItem(title: "次へ", style: .plain, target: self, action: #selector(self.tapEditFinish))
        self.navigationItem.setRightBarButtonItems([editfinishbutton], animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.auth.removeStateDidChangeListener(self.handle!)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapEditFinish(_ sender: UIBarButtonItem){
        if newEmail.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "新しいメールアドレスが記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else if newEmailRe.text!.isEmpty{
            let alertView = UIAlertController(title: "失敗しました", message: "新しいメールアドレスが記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }else if newEmail.text! != newEmailRe.text!{
            let alertView = UIAlertController(title: "失敗しました", message: "新しいメールアドレスが正しくありません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else {
            
            
           // var credential: AuthCredential
            
            //credential = EmailAuthProvider.credential(withEmail: <#T##String#>, password: user?.)
            
            // Prompt the user to re-provide their sign-in credentials
            /*
            user?.reauthenticate(with: credential) { error in
                if let error = error {
                    // An error happened.
                } else {
                    // User re-authenticated.
                }
            }
 */
          
            
            newAcountEmail = newEmail.text!
            
            
            //self.navigationController?.popViewController(animated: true)
            //Auth.auth().currentUser?.updateEmail(to: newAcountEmail, completion: nil)
            self.performSegue(withIdentifier: "toEmailCheck", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEmailCheck") {
            let EECVC = segue.destination as! EmailEditCheckViewController
            EECVC.newEmail = newAcountEmail
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 2
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        
        if indexPath.section == 0 {
            currentEmail = cell.viewWithTag(2) as! UITextField
            label.text = "現在のメールアドレス"
            currentEmail.text = AcountEmail
            currentEmail.delegate = self
            currentEmail.isEnabled = false
            
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                newEmail = cell.viewWithTag(2) as! UITextField
                label.text = "新しいメールアドレス"
                newEmail.text = ""
                newEmail.delegate = self
            } else if indexPath.row == 1{
                newEmailRe = cell.viewWithTag(2) as! UITextField
                label.text = "新しいメールアドレス(確認用)"
                newEmailRe.text = ""
                newEmailRe.delegate = self
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    

    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        newEmail.resignFirstResponder()
        newEmailRe.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newEmail.resignFirstResponder()
        newEmailRe.resignFirstResponder()
        return true
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
