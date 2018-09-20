//
//  NameEditViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/20.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseAuth

class NameEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var TableView: UITableView!
    
    var currentname: UITextField!
    var newname: UITextField!

    var AcountName = ""
    
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
            AcountName = user.displayName!
        }
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
        if newname.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "新しいアカウント名が記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else {
            
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
            
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.displayName = newname.text
        changeRequest?.commitChanges { (error) in
            // ...

            naviIndicatorView.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
        //self.dismiss(animated: true, completion: nil)

        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel

        if indexPath.row == 0 {
            currentname = cell.viewWithTag(2) as! UITextField
            label.text = "現在のアカウント名"
            currentname.text = AcountName
            currentname.delegate = self
            currentname.isEnabled = false
        } else if indexPath.row == 1{
            newname = cell.viewWithTag(2) as! UITextField
            label.text = "新しいアカウント名"
            newname.text = ""
            newname.delegate = self
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 90))
        
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        newname.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newname.resignFirstResponder()
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
