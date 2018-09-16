//
//  WordEditViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/08.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class WordEditViewController: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var edittextfield: UITextField!
    @IBOutlet weak var editimageview: UIImageView!
    @IBOutlet weak var edittextview: UITextView!
    
    var ref: DatabaseReference!
    var storage = Storage.storage()
    
    var selectDic = myDic(dictitle: "",dicid: "")
    var dicid = ""
    var selectpage = -1
    var selectpicture:UIImage? = UIImage()
    var selectpicturekey = String()
    var backgroundTaskID : UIBackgroundTaskIdentifier = 1
    
    var picker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edittextfield.delegate = self
        
         ref = Database.database().reference()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewWordViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)

        edittextview.layer.cornerRadius = 5
        edittextview.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        edittextview.layer.borderWidth = 1
        
        let storageRef = storage.reference()
        let reference = storageRef.child("users/dictionarylist/\(dicid)/words/\(selectDic.words[selectpage].wordid!)")
        print("wordid:\(selectDic.words[selectpage].wordid!)")
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                let imagePickUpButton:UIButton = UIButton()
                imagePickUpButton.addTarget(self, action: #selector(self.imagePickUpButtonClicked(_:)), for: .touchUpInside)
                imagePickUpButton.setImage(UIImage(named: "AddPhoto"), for: UIControlState.normal)
                imagePickUpButton.sizeToFit()
                let pickbuttonwidth =  imagePickUpButton.frame.width
                let pickbuttonheight = imagePickUpButton.frame.height
                imagePickUpButton.frame = CGRect(x: self.editimageview.frame.width - pickbuttonwidth, y: self.editimageview.frame.height - pickbuttonheight, width:pickbuttonwidth, height:pickbuttonheight )
                imagePickUpButton.tag = 0
                self.editimageview.addSubview(imagePickUpButton)
                
            } else {
                let image = UIImage(data: data!)
                self.editimageview.image = image
                self.selectpicture = image
                
                let imagedeletebutton:UIButton = UIButton()
                imagedeletebutton.frame =  CGRect(x: 2, y: 0, width: 40, height: 40)
                imagedeletebutton.addTarget(self, action: #selector(self.imagedelete), for: .touchUpInside)
                imagedeletebutton.setImage(UIImage(named: "Cansel"), for: UIControlState.normal)
                imagedeletebutton.sizeToFit()
                imagedeletebutton.tag = 1
                self.editimageview.addSubview(imagedeletebutton)
                
            }
        }
        /*
        let filename = getDocumentsDirectory().appendingPathComponent(selectDic.words[selectpage].wordpicturekey)
        
        if let imageDate:NSData = NSData(contentsOf: filename){
            editimageview.image = UIImage(data:imageDate as Data)
            selectpicture = editimageview.image
        }
        
        if let _:NSData = NSData(contentsOf: filename){
            let imagedeletebutton:UIButton = UIButton()
            imagedeletebutton.frame =  CGRect(x: 2, y: 0, width: 40, height: 40)
            imagedeletebutton.addTarget(self, action: #selector(self.imagedelete), for: .touchUpInside)
            imagedeletebutton.setImage(UIImage(named: "Cansel"), for: UIControlState.normal)
            imagedeletebutton.sizeToFit()
            imagedeletebutton.tag = 1
            editimageview.addSubview(imagedeletebutton)
        }else{
            let imagePickUpButton:UIButton = UIButton()
            imagePickUpButton.addTarget(self, action: #selector(self.imagePickUpButtonClicked(_:)), for: .touchUpInside)
            imagePickUpButton.setImage(UIImage(named: "AddPhoto"), for: UIControlState.normal)
            imagePickUpButton.sizeToFit()
            let pickbuttonwidth =  imagePickUpButton.frame.width
            let pickbuttonheight = imagePickUpButton.frame.height
            imagePickUpButton.frame = CGRect(x: editimageview.frame.width - pickbuttonwidth, y: editimageview.frame.height - pickbuttonheight, width:pickbuttonwidth, height:pickbuttonheight )
            imagePickUpButton.tag = 0
            editimageview.addSubview(imagePickUpButton)
        }
 */
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.tintColor = UIColor.black
        
        //selectDic.fetchWordList(row: Int(selectDic.dicid)!)
        
        print("編集するページは\(selectpage)")
        edittextfield.text = selectDic.words[selectpage].wordtitle
        edittextview.text = selectDic.words[selectpage].wordmean
        
       
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Clear"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WordEditViewController.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "check"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WordEditViewController.editfinish))
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            editimageview.image = image
            selectpicture = image
            
            let imagedeletebutton:UIButton = UIButton()
            imagedeletebutton.frame =  CGRect(x: 2, y: 0, width: 40, height: 40)
            imagedeletebutton.addTarget(self, action: #selector(self.imagedelete), for: .touchUpInside)
            imagedeletebutton.setImage(UIImage(named: "Cansel"), for: UIControlState.normal)
            imagedeletebutton.sizeToFit()
            imagedeletebutton.tag = 1
            editimageview.addSubview(imagedeletebutton)
            
            let subviews = editimageview.subviews
            for subview in subviews {
                if subview.tag == 0 {
                    subview.removeFromSuperview()
                }
            }
            
        } else{
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagedelete() {
        editimageview.image = UIImage()
        selectpicture = nil
        let subviews = editimageview.subviews
        for subview in subviews {
            if subview.tag == 1 {
                subview.removeFromSuperview()
            }
        }
        
        let imagePickUpButton:UIButton = UIButton()
        imagePickUpButton.addTarget(self, action: #selector(self.imagePickUpButtonClicked(_:)), for: .touchUpInside)
        imagePickUpButton.setImage(UIImage(named: "AddPhoto"), for: UIControlState.normal)
        imagePickUpButton.sizeToFit()
        let pickbuttonwidth =  imagePickUpButton.frame.width
        let pickbuttonheight = imagePickUpButton.frame.height
        imagePickUpButton.frame = CGRect(x: editimageview.frame.width - pickbuttonwidth, y: editimageview.frame.height - pickbuttonheight, width:pickbuttonwidth, height:pickbuttonheight )
        imagePickUpButton.tag = 0
        editimageview.addSubview(imagePickUpButton)
        
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func editfinish(){
        
        if edittextfield.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "単語名が記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
            
        } else {
        

            /*
        if  let selectpicture = selectpicture{
            //let picture = pictureconversion(picture: selectpicture)
            //UserDefaults.standard.set(picture, forKey: selectDic.words[selectpage].wordpicturekey)
            
        }else{
            //let picture = UIImageJPEGRepresentation(UIImage(named: "noImage.png")!, 1)
            //UserDefaults.standard.set(nil, forKey: selectDic.words[selectpage].wordpicturekey)
        }
 */
 
        selectDic.words[selectpage].wordtitle = edittextfield.text
        selectDic.words[selectpage].wordmean = edittextview.text
       // self.selectDic.save(row: Int(selectDic.dicid)!)
       // saveImageToDocumentsDirectory(image: selectpicture!, key: selectDic.words[selectpage].wordpicturekey)
            
            for word in selectDic.words {
                if word.wordid == selectDic.words[selectpage].wordid {
                    word.wordtitle = selectDic.words[selectpage].wordtitle
                    word.wordmean = selectDic.words[selectpage].wordmean
                    let wordtitledata = ["wordtitle":selectDic.words[selectpage].wordtitle]
                    ref.child("users/dictionarylist/\(self.dicid)/words/\(word.wordid!)").updateChildValues(wordtitledata)
                    let wordmeandata = ["wordmean":selectDic.words[selectpage].wordmean]
                    ref.child("users/dictionarylist/\(self.dicid)/words/\(word.wordid!)").updateChildValues(wordmeandata)
                    
                    if selectpicture != nil {
                        var resize = 1.0
                        var data = UIImageJPEGRepresentation(selectpicture!,CGFloat(resize))!
                        while data.count > 1048576 {
                            resize = resize/2
                            data = UIImageJPEGRepresentation(selectpicture!,CGFloat(resize))!
                        }
                        
                        let storageRef = storage.reference()
                        let reference = storageRef.child("users/dictionarylist/\(dicid)/words/\(word.wordid!)")
                        reference.putData(data, metadata: nil, completion: { metaData, error in
                            print("metaData:\(metaData as Any)")
                            print("error:\(error as Any)")
                        })
                    } else {
                        let storageRef = storage.reference()
                        let reference = storageRef.child("users/dictionarylist/\(dicid)/words/\(word.wordid!)")
                        reference.delete { error in
                            if error != nil {
                                // Uh-oh, an error occurred!
                            } else {
                                // File deleted successfully
                            }
                        }
                    }
                    
                }
            }
        
         self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    /*
    func pictureconversion(picture: UIImage) -> NSData?{
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        let picturedata = UIImageJPEGRepresentation(picture, 1)
        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
        return picturedata as NSData?
    }
 */
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func saveImageToDocumentsDirectory(image: UIImage, key: String) {
        let data = UIImageJPEGRepresentation(image,1)
        let filename = getDocumentsDirectory().appendingPathComponent(key)
        try? data?.write(to: filename)
        
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        edittextfield.resignFirstResponder()
        edittextview.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edittextfield.resignFirstResponder()
        return true
    }
    
}
