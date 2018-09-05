//
//  NewWordViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class NewWordViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var newWordtitle: UITextField!
    @IBOutlet weak var newWordmean: UITextView!
    @IBOutlet weak var newWordpictureview: UIImageView!
    
    
    var mydiclist = DicList.sharedInstance
    var selectDic = myDic(dictitle: "",dicid: "")
    var selectDicNum = 0
    var selectpicture:UIImage? = UIImage()
    var selectpicturekey = String()
    var dicid = -1
    
    var picker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        newWordmean.layer.cornerRadius = 5
        newWordmean.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        newWordmean.layer.borderWidth = 1
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewWordViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        newWordtitle.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewWordViewController.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewWordViewController.save))
        
        let imagePickUpButton:UIButton = UIButton()
        imagePickUpButton.frame = CGRect(x: newWordpictureview.frame.width - 100, y: newWordpictureview.frame.height - 20, width: 80, height: 40)
        imagePickUpButton.addTarget(self, action: #selector(self.imagePickUpButtonClicked(_:)), for: .touchUpInside)
        imagePickUpButton.backgroundColor = UIColor.gray
        imagePickUpButton.setTitle("画像追加", for: UIControlState.normal)
        newWordpictureview.addSubview(imagePickUpButton)
        
        
        mydiclist.fetchDicList()
        
    }
    
    @objc func imagePickUpButtonClicked(_ sender: UIButton){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self
        picker.navigationBar.tintColor = UIColor.black
        picker.navigationBar.barTintColor = UIColor.white
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newWordpictureview.image = image
            selectpicture = image
        } else{
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @objc func save() {
        if newWordtitle.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "単語名が記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        
        } else {
            
            if  let selectpicture = selectpicture{
                selectpicturekey = String(Int(Date().timeIntervalSince1970))
                let word = Word(wordtitle: newWordtitle.text!, wordmean: newWordmean.text!,wordpicturekey: selectpicturekey)
                self.selectDic.addWordList(word: word, row: self.dicid)
                
                UserDefaults.standard.set(UIImageJPEGRepresentation(selectpicture, 1), forKey: selectpicturekey)
            } else {
                selectpicturekey = String(Int(Date().timeIntervalSince1970))
                let word = Word(wordtitle: newWordtitle.text!, wordmean: newWordmean.text!,wordpicturekey: selectpicturekey)
                self.selectDic.addWordList(word: word, row: self.dicid)
                //selectpicture = UIImage(named: "noImage.png")
                UserDefaults.standard.set(UIImageJPEGRepresentation(UIImage(named: "noImage.png")!, 1), forKey: selectpicturekey)
                
            }
            
            
            self.dismiss(animated: true, completion: nil)
       
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        newWordtitle.resignFirstResponder()
        newWordmean.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newWordtitle.resignFirstResponder()
        return true
    }
    /*
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mydiclist.dics.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mydiclist.dics[row].dictitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newWorddic.text = self.mydiclist.dics[row].dictitle
        self.selectDic = self.mydiclist.dics[row]
        self.dicid = Int(self.mydiclist.dics[row].dicid)!
        print(self.selectDic.dictitle)
        print(self.dicid)
        selectDic.fetchWordList(row: dicid)
        for title in self.selectDic.words{
            print(title.wordtitle)
        }
    }
    
    @objc func cancel() {
        self.newWorddic.text = ""
        self.newWorddic.endEditing(true)
    }
    
    @objc func done() {
        self.newWorddic.endEditing(true)
    }
 
    
    @objc func addnewDic(){
        let t = Int(Date().timeIntervalSince1970)
        self.dicid = t
        print("newid:\(self.dicid)")
        self.performSegue(withIdentifier: "toNewDic", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toNewDic") {
            let nc = segue.destination as! UINavigationController
            let NDVC = nc.topViewController as! NewDicViewController
            NDVC.dicid = self.dicid
        }
    }
 */

}
