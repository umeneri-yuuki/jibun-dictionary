//
//  FirstViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/17.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // navigationController?.navigationBar.isHidden = true
    }

    
    
    @IBAction func LogInButton(_ sender: UIButton) {
         performSegue(withIdentifier: "toLogInView",sender:nil)    }
    
    @IBAction func RegistarButton(_ sender: UIButton) {
         performSegue(withIdentifier: "toRegisterView",sender:nil)
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
