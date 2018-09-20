//
//  EmailEditCheckViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/20.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailEditCheckViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var password: UITextField!
    var newEmail = ""
    
    var auth: Auth!
    var handle: AuthStateDidChangeListenerHandle?
    let user = Auth.auth().currentUser

    @IBOutlet weak var TableView: UITableView!
    
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
        
            let editfinishbutton :UIBarButtonItem = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.tapEditFinish))
         self.navigationItem.setRightBarButtonItems([editfinishbutton], animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func tapEditFinish(_ sender: UIBarButtonItem){
        
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
        /*
         var credential: AuthCredential
        credential = EmailAuthProvider.credential(withEmail: newEmail, password: password.text!)
        
        // Prompt the user to re-provide their sign-in credentials
        
         user?.reauthenticate(with: credential) { error in
            if error != nil {
             // An error happened.
             } else {
                Auth.auth().currentUser?.updateEmail(to: self.newEmail, completion: nil)
             // User re-authenticated.
             }
         }
        */
        self.auth.signIn(withEmail: (user?.email)!, password: self.password.text!) { (authResult, error) in
            if (error == nil) {

                
                Auth.auth().currentUser?.updateEmail(to: self.newEmail) { (error) in
                    // ...
                     if (error == nil) {
                        naviIndicatorView.removeFromSuperview()
                    self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
                     }else{
                        
                    }
                }
                
            } else {
                IndicatorView.removeFromSuperview()
                naviIndicatorView.removeFromSuperview()
                
                let alertView = UIAlertController(title: "失敗しました", message: "パスワードが正しくありません", preferredStyle: UIAlertControllerStyle.alert)
                alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertView, animated: true, completion: nil)
            }
        }
        
        
       // navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        

            password = cell.viewWithTag(2) as! UITextField
            label.text = "パスワード"
            password.text = ""
            password.delegate = self

        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        password.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        password.resignFirstResponder()
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
