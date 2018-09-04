//
//  NewWordViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class NewWordViewController: UIViewController, UITextFieldDelegate{
//, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var newWordtitle: UITextField!
    @IBOutlet weak var newWorddic: UITextField!
    @IBOutlet weak var newWordmean: UITextView!
    
    var mydiclist = DicList.sharedInstance
    var selectDic = myDic(dictitle: "",dicid: "")
    var selectDicNum = 0
    var dicid = -1
    //var pickerView: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(selectDic.dictitle)

        
        newWordmean.layer.cornerRadius = 5
        newWordmean.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        newWordmean.layer.borderWidth = 1
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewWordViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        newWordtitle.delegate = self
       
        /*
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
 
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let addDic = UIBarButtonItem(title: "辞書を追加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addnewDic))
        toolbar.setItems([cancelItem, doneItem, flexibleItem, addDic], animated: true)
        
        
        self.newWorddic.inputView = pickerView
        self.newWorddic.inputAccessoryView = toolbar
        */
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewWordViewController.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewWordViewController.save))
        
        mydiclist.fetchDicList()
        
    }
    
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @objc func save() {
        if newWordtitle.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "単語名が記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        /*
             } else if newWorddic.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "辞書が選択されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
            */
        } else {
            let word = Word(wordtitle: newWordtitle.text!, wordmean: newWordmean.text!)
            self.selectDic.addWordList(word: word, row: self.dicid)
            print(selectDic.words[selectDic.words.count - 1].wordtitle)
            /*
            self.newWordtitle.text = ""
            self.newWorddic.text = ""
            self.newWordmean.text = ""
 */
            self.dismiss(animated: true, completion: nil)
            /*
            newWordtitle.resignFirstResponder()
            newWordmean.resignFirstResponder()
            self.newWorddic.endEditing(true)
 */
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
