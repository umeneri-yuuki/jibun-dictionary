//
//  PasswordEditViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/20.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var TableView: UITableView!
    
    var currentPassword: UITextField!
    var newPassword: UITextField!
    var newPasswordRe: UITextField!
    
    var newAcountPassword = ""
    
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
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.handle = self.auth.addStateDidChangeListener { (auth, user) in
        }
        
        let editfinishbutton :UIBarButtonItem = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.tapEditFinish))
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
        if newPassword.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "新しいパスワードが記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else if newPasswordRe.text!.isEmpty{
            let alertView = UIAlertController(title: "失敗しました", message: "新しいパスワードが記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else if currentPassword.text!.isEmpty{
            let alertView = UIAlertController(title: "失敗しました", message: "現在のパスワードが記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }else if newPassword.text! != newPasswordRe.text!{
            let alertView = UIAlertController(title: "失敗しました", message: "新しいパスワードが正しくありません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else {
            
            self.auth.signIn(withEmail: (user?.email)!, password: currentPassword.text!) { (authResult, error) in
                if (error == nil) {
                    let size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
                    let IndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    IndicatorView.backgroundColor = UIColor.black
                    IndicatorView.alpha = 0.7
                    
                    let naviH: CGFloat = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height
                    let naviIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: naviH))
                    naviIndicatorView.backgroundColor = UIColor.black
                    naviIndicatorView.alpha = 0.7
                    
                    let ActivityIndicator = UIActivityIndicatorView()
                    ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                    ActivityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
                    ActivityIndicator.center = self.view.center
                    ActivityIndicator.color = UIColor.white
                    IndicatorView.addSubview(ActivityIndicator)
                    
                    self.view.addSubview(IndicatorView)
                    self.navigationController!.view.addSubview(naviIndicatorView)
                    
                    ActivityIndicator.startAnimating()
                    
                    
                    
                    Auth.auth().currentUser?.updatePassword(to: self.newPassword.text!) { (error) in
                        // ...
                         if (error == nil) {
                        naviIndicatorView.removeFromSuperview()
                        self.navigationController?.popViewController(animated: true)
                         }else{
                            
                        }
                    }
                } else {
                    let alertView = UIAlertController(title: "失敗しました", message: "パスワードが正しくありません", preferredStyle: UIAlertControllerStyle.alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                }
            }
            
            
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
            
            
          //  newAcountPassword = newPassword.text!
            
            
            
            
            
  
            //Auth.auth().currentUser?.updateEmail(to: newAcountEmail, completion: nil)
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
            currentPassword = cell.viewWithTag(2) as! UITextField
            label.text = "現在のパスワード"
            currentPassword.text = ""
            currentPassword.delegate = self
            
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                newPassword = cell.viewWithTag(2) as! UITextField
                label.text = "新しいパスワード"
                newPassword.text = ""
                newPassword.delegate = self
                
            } else if indexPath.row == 1{
                newPasswordRe = cell.viewWithTag(2) as! UITextField
                label.text = "新しいパスワード(確認用)"
                newPasswordRe.text = ""
                newPasswordRe.delegate = self
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
        currentPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        newPasswordRe.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        newPasswordRe.resignFirstResponder()
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
