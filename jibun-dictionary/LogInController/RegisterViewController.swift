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

    @IBOutlet weak var RegisterEmail: UITextField!
    @IBOutlet weak var RegisterPassword: UITextField!
    
    var auth: Auth!
    var handle: AuthStateDidChangeListenerHandle?
    var isLogIn: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        RegisterEmail.delegate = self
        RegisterPassword.delegate = self
        
       s

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
            self.auth.createUser(withEmail: self.RegisterEmail.text!, password: self.RegisterPassword.text!) { (authResult, error) in
                if error == nil {
                    self.isLogIn = true
                    print((authResult?.user.email))
                    print((authResult?.user.uid))
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                }
            }
        }


    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        RegisterEmail.resignFirstResponder()
        RegisterPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
