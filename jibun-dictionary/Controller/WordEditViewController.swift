//
//  WordEditViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/08.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit

class WordEditViewController: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var edittextfield: UITextField!
    @IBOutlet weak var editimageview: UIImageView!
    @IBOutlet weak var edittextview: UITextView!
    
    var selectDic = myDic(dictitle: "",dicid: "")
    var dicid = -1
    var selectpage = -1
    var selectpicture:UIImage? = UIImage()
    var selectpicturekey = String()
    
    var picker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edittextfield.delegate = self
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewWordViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)

        edittextview.layer.cornerRadius = 5
        edittextview.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        edittextview.layer.borderWidth = 1
        
        if let imageDate:NSData = UserDefaults.standard.object(forKey: selectpicturekey) as? NSData {
            editimageview.image = UIImage(data:imageDate as Data)
            selectpicture = editimageview.image
        }
        
        if let _:NSData = UserDefaults.standard.object(forKey: selectpicturekey) as? NSData {
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.tintColor = UIColor.black
        
        selectDic.fetchWordList(row: dicid)
        
        print("編集するページは\(selectpage)")
        edittextfield.text = selectDic.words[selectpage].wordtitle
        edittextview.text = selectDic.words[selectpage].wordmean
        
       
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Clear"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WordEditViewController.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "check"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WordEditViewController.editfinish))
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        selectpicture = UIImage()
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
        
        if  let selectpicture = selectpicture{
            UserDefaults.standard.set(UIImageJPEGRepresentation(selectpicture, 1), forKey: selectpicturekey)
        }else{
            UserDefaults.standard.set(UIImageJPEGRepresentation(UIImage(named: "noImage.png")!, 1), forKey: selectpicturekey)
        }
        selectDic.words[selectpage].wordtitle = edittextfield.text
        selectDic.words[selectpage].wordmean = edittextview.text
        self.selectDic.save(row: dicid)
         self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        edittextfield.resignFirstResponder()
        edittextview.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edittextfield.resignFirstResponder()
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
