//
//  NewWordViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/08/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class NewWordViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var newWordtitle: UITextField!
    @IBOutlet weak var newWordmean: UITextView!
    @IBOutlet weak var newWordpictureview: UIImageView!
    var ref: DatabaseReference!
    var storage = Storage.storage()

    
   // var mydiclist = DicList.sharedInstance
    var selectDic = myDic(dictitle: "",dicid: "")
    var selectDicNum = 0
    var wordcount = 0
    var selectpicture:UIImage? = UIImage()
    var selectpicturekey = String()
    var userid = ""
    var dicid = ""
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    
    var picker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        newWordmean.layer.cornerRadius = 5
        newWordmean.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        newWordmean.layer.borderWidth = 1
        
        newWordmean.text = "意味・コメントを入力"
        newWordmean.textColor = UIColor.lightGray
        newWordmean.alpha = 0.7
        newWordmean.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewWordViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        newWordtitle.delegate = self

            let imagePickUpButton:UIButton = UIButton()
            imagePickUpButton.addTarget(self, action: #selector(self.imagePickUpButtonClicked(_:)), for: .touchUpInside)
            imagePickUpButton.setImage(UIImage(named: "AddPhoto"), for: UIControlState.normal)
            imagePickUpButton.sizeToFit()
            let pickbuttonwidth =  imagePickUpButton.frame.width
            let pickbuttonheight = imagePickUpButton.frame.height
            imagePickUpButton.frame = CGRect(x: newWordpictureview.frame.width - pickbuttonwidth, y: newWordpictureview.frame.height - pickbuttonheight, width:pickbuttonwidth, height:pickbuttonheight )
            imagePickUpButton.tag = 0
            newWordpictureview.addSubview(imagePickUpButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Clear"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewWordViewController.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Add"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewWordViewController.save))
        
        //mydiclist.fetchDicList()
      //  selectDic.fetchWordList(row: Int(selectDic.dicid)!)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if newWordmean.textColor == UIColor.lightGray {
            newWordmean.text = nil
            newWordmean.textColor = UIColor.black
            newWordmean.alpha = 1.0
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if newWordmean.text.isEmpty {
            newWordmean.text = "意味・コメントを入力"
            newWordmean.textColor = UIColor.lightGray
            newWordmean.alpha = 0.7
        }
    }
    
    @objc func imagePickUpButtonClicked(_ sender: UIButton){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self
        picker.navigationBar.tintColor = UIColor.black
        picker.navigationBar.barTintColor = UIColor.white
        selectpicture = nil
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newWordpictureview.image = image
            selectpicture = image
            
            let imagedeletebutton:UIButton = UIButton()
            imagedeletebutton.frame =  CGRect(x: 2, y: 0, width: 40, height: 40)
            imagedeletebutton.addTarget(self, action: #selector(self.imagedelete), for: .touchUpInside)
            imagedeletebutton.setImage(UIImage(named: "Cansel"), for: UIControlState.normal)
            imagedeletebutton.sizeToFit()
            imagedeletebutton.tag = 1
            newWordpictureview.addSubview(imagedeletebutton)
            
            let subviews = newWordpictureview.subviews
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
        newWordpictureview.image = UIImage()
        //selectpicture = UIImage()
        selectpicture = nil
        let subviews = newWordpictureview.subviews
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
        imagePickUpButton.frame = CGRect(x: newWordpictureview.frame.width - pickbuttonwidth, y: newWordpictureview.frame.height - pickbuttonheight, width:pickbuttonwidth, height:pickbuttonheight )
        imagePickUpButton.tag = 0
        newWordpictureview.addSubview(imagePickUpButton)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @objc func save() {
        
        newWordtitle.resignFirstResponder()
        newWordmean.resignFirstResponder()
        
        if newWordtitle.text!.isEmpty {
            let alertView = UIAlertController(title: "失敗しました", message: "単語名が記述されていません", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        
        } else {
            
            if newWordmean.textColor == UIColor.lightGray {
                newWordmean.text = ""
            }
            
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
            
           // if let selectpicture = selectpicture{a
            
                selectpicturekey = String(Int(Date().timeIntervalSince1970))
                //let word = Word(wordtitle: newWordtitle.text!, wordmean: newWordmean.text!,wordpicturekey: selectpicturekey)
                //self.selectDic.addWordList(word: word)
                //self.selectDic.save(row: Int(selectDic.dicid)!)
                //let picture = UIImageJPEGRepresentation(selectpicture!, 1)
                //let picture = pictureconversion(picture: selectpicture!)
                //UserDefaults.standard.set(picture, forKey: selectpicturekey)
               // saveImageToDocumentsDirectory(image: selectpicture!, key: selectpicturekey)
            
                let wordid = ref.child("alldictionarylist/\(dicid)/words").childByAutoId().key
                let newword = Word()
                newword.wordtitle = newWordtitle.text!
                newword.wordid = wordid
                newword.wordmean = newWordmean.text!
                newword.wordpos = wordcount
                self.selectDic.addWordList(word: newword)
            
                let wordtitledata = ["wordtitle": newWordtitle.text!]
                let wordmeandata = ["wordmean": newWordmean.text!]
                let wordiddata = ["wordid": wordid]
                let wordposdata = ["wordpos": wordcount]
            
                ref.child("alldictionarylist/\(dicid)/words/\(wordid!)").updateChildValues(wordtitledata)
                ref.child("alldictionarylist/\(dicid)/words/\(wordid!)").updateChildValues(wordmeandata)
                ref.child("alldictionarylist/\(dicid)/words/\(wordid!)").updateChildValues(wordiddata)
                ref.child("alldictionarylist/\(dicid)/words/\(wordid!)").updateChildValues(wordposdata)
            
            
            if selectpicture != nil {
            var resize = 1.0
                var data = UIImageJPEGRepresentation(selectpicture!,CGFloat(resize))!
                while data.count > 1048576 {
                    resize = resize/2
                    data = UIImageJPEGRepresentation(selectpicture!,CGFloat(resize))!
                }
                
               let storageRef = storage.reference()
               let reference = storageRef.child("alldictionarylist/\(dicid)/words/\(wordid!)")
            reference.putData(data, metadata: nil, completion: { metaData, error in
                print("metaData:\(metaData as Any)")
                print("error:\(error as Any)")
                self.dismiss(animated: true, completion: nil)
            })
            }else{
               self.dismiss(animated: true, completion: nil)
            }
            
            /*
            } else {
                selectpicturekey = String(Int(Date().timeIntervalSince1970))
                let word = Word(wordtitle: newWordtitle.text!, wordmean: newWordmean.text!,wordpicturekey: selectpicturekey)
                self.selectDic.addWordList(word: word)
                self.selectDic.save(row: Int(selectDic.dicid)!)
                //let picture = UIImageJPEGRepresentation(UIImage(named: "noImage.png")!, 1)
                let picture = UIImageJPEGRepresentation(UIImage(named: "noImage.png")!, 1)
                UserDefaults.standard.set(picture, forKey: selectpicturekey)
                
            }
 */
 
            
            
  
       
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
   
}
