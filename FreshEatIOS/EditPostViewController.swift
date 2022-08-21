//
//  EditPostViewController.swift
//  FreshEatIOS
//
//  Created by Emil Kollek on 21/08/2022.
//

import UIKit
import SkeletonView
import SwiftUI

class EditPostViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    

    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var mainTxt: UITextView!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
   
    
    var post:Post?{
       didSet{
           if(titleTxt != nil){
               updateDisplay()
           }
       }
   }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTxt.layer.cornerRadius=10
        titleTxt.clipsToBounds = true
        mainTxt.layer.cornerRadius = 10
        mainTxt.clipsToBounds = true
        mainTxt.textContainer.maximumNumberOfLines = 5
        locationTxt.layer.cornerRadius = 10
        locationTxt.clipsToBounds = true
        phoneTxt.layer.cornerRadius = 10
        phoneTxt.clipsToBounds = true
        postImg.layer.cornerRadius = 10
        postImg.clipsToBounds = true
       
        
        if post != nil{
            updateDisplay()
        }
        
    }
    
    func updateDisplay(){
        self.startLoading()
        self.skelShow()
        editBtnOff()
        titleTxt.text = post?.title
        mainTxt.text = post?.postDescription
        locationTxt.text = post?.location
        phoneTxt.text = post?.contactPhone
        titleTxt.delegate = self
        mainTxt.delegate = self
        locationTxt.delegate = self
        phoneTxt.delegate = self
        
        if let urlStr = post?.photo {
            if (!urlStr.elementsEqual("vegImg")){
                let url = URL(string: urlStr)
                postImg?.kf.setImage(with: url,completionHandler: { result in
                    self.stopSkel()
                    self.stopLoading()
                })
            }else{
                postImg.image = UIImage(named: "vegImg")
                self.stopSkel()
                self.stopLoading()
            }
        }
        
        self.selectedImage = nil
    }
    
    func skelShow(){
        self.view.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
    }
    
    func stopSkel(){
        self.view.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentTxt = textField.text ?? ""
        guard let stringRange = Range(range, in: currentTxt) else {
            return false
        }
        
        let updateText = currentTxt.replacingCharacters(in: stringRange, with: string)
        return updateText.count < 30
    
    }
    
    
   
    
       
    func editBtnOn(){
        editBtn.isEnabled = true
        editBtn.configuration?.cornerStyle = .capsule
        editBtn.layer.cornerCurve = .continuous
        editBtn.layer.cornerRadius = 15
        editBtn.layer.borderWidth = 3
        editBtn.layer.borderColor = UIColor(red: 0.39216, green: 0.65490, blue: 0.26667, alpha: 1.0).cgColor

        
        
        
        
    }
    
    func editBtnOff(){
        editBtn.isEnabled = false
        editBtn.layer.borderWidth = 0
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentTxt = textView.text ?? ""
        guard let textRange = Range(range, in: currentTxt) else {
            return false
        }
        
        let updateText = currentTxt.replacingCharacters(in: textRange, with: text)
        return updateText.count < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
          textView.text = ""
            textView.textColor = UIColor.black
        }
               
    }
    
    func textViewDidChange(_ textView: UITextView){
        if mainTxt.text == post!.postDescription{
            editBtnOff()
        }
        else {
            editBtnOn()
    
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField){
        if titleTxt.text == post!.title && locationTxt.text == post!.location && phoneTxt.text == post!.contactPhone{
            editBtnOff()
        }
        else{
            editBtnOn()
        }
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What Do You Offer?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    

    @IBAction func restoreBtn(_ sender: Any) {
        updateDisplay()
    }
    
    @IBAction func changeImgBtn(_ sender: Any) {
        takePicture(source: .photoLibrary)
    }
    
    func takePicture(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source;
        imagePicker.allowsEditing = true
        if (UIImagePickerController.isSourceTypeAvailable(source))
        {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var selectedImage: UIImage? = nil
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        self.postImg.image = selectedImage
        editBtnOn()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        let title = titleTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = mainTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let location = locationTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = phoneTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var fields = [String]()
        fields.append(title)
        fields.append(description)
        fields.append(location)
        fields.append(phone)

        if !Model.instance.validateFields(fields: fields){
            self.popupAlert(title: "Error Posting",
                            message: "You must fill in all of the fields",
                            actionTitles: ["OK"], actions: [nil])
            return
        }
        
        if !Model.instance.isValidIsraeliPhone(phone: phone){
            self.popupAlert(title: "Error Posting",
                            message: "You must enter a valid Israeli Phone Number",
                            actionTitles: ["OK"], actions: [nil])
            return
        }
        
        self.startLoading()
        self.disableTabBar()
        var data = [String:Any]()
        data["title"] = title
        data["postDescription"] = description
        data["location"] = location
        data["contactPhone"] = phone
        
        //User has selected image
        if let image = self.selectedImage{
            Model.instance.uploadImage(name: post!.id!, image: image) { url in
                data["photo"] = url
                Model.instance.editPost(post: self.post!, data: data) {
                    self.stopLoading()
                    self.enableTabBar()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        else{
            Model.instance.editPost(post: self.post!, data: data) {
                self.stopLoading()
                self.enableTabBar()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    func disableTabBar(){
        for tabBarItem in self.tabBarController?.tabBar.items ?? []{
            tabBarItem.isEnabled = false
        }
    }
    
    func enableTabBar(){
        for tabBarItem in self.tabBarController?.tabBar.items ?? []{
            tabBarItem.isEnabled = true
        }
    }
    
}

