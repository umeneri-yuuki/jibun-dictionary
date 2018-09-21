//
//  RegisterViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/17.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var RegisterAcountName: UITextField!
    @IBOutlet weak var RegisterEmail: UITextField!
    @IBOutlet weak var RegisterPassword: UITextField!
    
    var auth: Auth!
    var handle: AuthStateDidChangeListenerHandle?
    var isLogIn: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        RegisterAcountName.delegate = self
        RegisterEmail.delegate = self
        RegisterPassword.delegate = self
        
        self.auth = Auth.auth()
        self.isLogIn = false

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handle = self.auth.addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.auth.removeStateDidChangeListener(self.handle!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Register(_ sender: UIButton) {
        
        RegisterAcountName.resignFirstResponder()
        RegisterEmail.resignFirstResponder()
        RegisterPassword.resignFirstResponder()
        
        
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
        
            self.auth.createUser(withEmail: self.RegisterEmail.text!, password: self.RegisterPassword.text!) { (authResult, error) in
                if error == nil {
                    self.isLogIn = true
                    print((authResult?.user.email))
                    print((authResult?.user.uid))
                    let changeRequest = authResult?.user.createProfileChangeRequest()
                    changeRequest?.displayName = self.RegisterAcountName.text
                    changeRequest?.commitChanges { (error) in
                        // ...
                    }
                   // self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                } else {
                }
            }
        
        }


    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        RegisterAcountName.resignFirstResponder()
        RegisterEmail.resignFirstResponder()
        RegisterPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        RegisterAcountName.resignFirstResponder()
        RegisterEmail.resignFirstResponder()
        RegisterPassword.resignFirstResponder()
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
