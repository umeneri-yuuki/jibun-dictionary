//
//  AcountViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/20.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseAuth

class AcountViewController: UIViewController {
    
    var auth: Auth!
    var handle: AuthStateDidChangeListenerHandle?
    let user = Auth.auth().currentUser

    @IBOutlet weak var AcountName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        self.auth = Auth.auth()



        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        let acounteditbutton :UIBarButtonItem = UIBarButtonItem(title: "設定", style: .plain, target: self, action: #selector(self.tapAcountEdit))
        self.navigationItem.setRightBarButtonItems([acounteditbutton], animated: true)
        
        if let user = user {
            AcountName.text = user.displayName
        }
        
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
    
    
    @objc func tapAcountEdit(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "toAcountEdit",sender:nil)

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
