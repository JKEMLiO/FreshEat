//
//  NewPostViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 02/08/2022.
//

import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var mainInput: UITextView!
    @IBOutlet weak var imgPost: UIImageView!

    var titlePH = ""
    var locationPH = ""
    var phonePH = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.prepareView()
         
    }

   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentTxt = textField.text ?? ""
        guard let stringRange = Range(range, in: currentTxt) else {
            return false
        }
        
        let updateText = currentTxt.replacingCharacters(in: stringRange, with: string)
        if textField==phoneInput{
            return updateText.count < 11
        }
        return updateText.count < 31
    
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
    
        
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What Do You Offer?"
            textView.textColor = UIColor.lightGray
        }
    }
    
//    func textFieldDidBeginEditing(_ textField:UITextField){
//        textField.placeholder=""
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((titleInput.text?.isEmpty) != nil){
            titleInput.placeholder = titlePH
        }
        if ((locationInput.text?.isEmpty) != nil){
            locationInput.placeholder = locationPH
        }
        if ((phoneInput.text?.isEmpty) != nil){
            phoneInput.placeholder = phonePH
        }
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        zeroValues()
    }
    
   
    @IBAction func uploadImage(_ sender: UIButton) {
        takePicture(source: .photoLibrary)
    }
    
    @IBAction func uploadPost(_ sender: UIButton) {
        
        let title = titleInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = mainInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let location = locationInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = phoneInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
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
            self.phoneInput.text = ""
            return
        }
        
        self.startLoading()
        self.disableTabBar()
        
        getWeatherDetailsByCity(city: location) { weatherData in
            if weatherData != nil{
                let post = Post()
                post.id = UUID().uuidString
                post.title = title
                post.postDescription = description
                post.location = location
                post.isPostDeleted = false
                post.contactPhone = phone
                Model.instance.getCurrentUser { user in
                    if user != nil {
                        post.username = user?.name
                        post.contactEmail = user?.email
                        //User has selected image
                        if let image = self.selectedImage{
                            Model.instance.uploadImage(name: post.id!, image: image) { url in
                                post.photo = url
                                Model.instance.addPost(post: post) {
                                    self.tabBarController?.selectedIndex = 0
                                    self.stopLoading()
                                    self.enableTabBar()
                                    self.zeroValues()
                                }
                            }
                        }
                        //User hasn't selected image
                        else{
                            post.photo = "vegImg"
                            Model.instance.addPost(post: post) {
                                self.tabBarController?.selectedIndex = 0
                                self.stopLoading()
                                self.enableTabBar()
                                self.zeroValues()
                            }
                        }
                    }
                    else{
                        self.stopLoading()
                        self.enableTabBar()
                        self.popupAlert(title: "Error Adding Post",
                                        message: "An issue has occured...\nTry logout and then login back to the app",
                                        actionTitles: ["OK"], actions: [nil])
                    }
                }
            }
            else{
                self.stopLoading()
                self.enableTabBar()
                self.popupAlert(title: "Error Posting",
                                message: "You must enter a valid city",
                                actionTitles: ["OK"], actions: [nil])
                self.locationInput.text = ""
                return
            }
        }
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
    
    var selectedImage: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage
        self.imgPost.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func zeroValues(){
        titleInput.text = nil
        locationInput.text = nil
        mainInput.text = nil
        phoneInput.text = nil
        mainInput.text = "What Do You Offer?"
        mainInput.textColor = UIColor.lightGray
        selectedImage = UIImage(named: "vegImg")
        imgPost.image = selectedImage
        titleInput.becomeFirstResponder()
    }
    
    func prepareView(){
        self.enableTabBar()
        imgPost.layer.cornerRadius=15
        imgPost.clipsToBounds=true
        imgPost.layer.borderWidth = 1
        imgPost.layer.borderColor = UIColor(red: 0.39216, green: 0.65490, blue: 0.26667, alpha: 1.0).cgColor
        titleInput.layer.cornerRadius=10
        titleInput.clipsToBounds=true
        titlePH = titleInput.placeholder!
        titleInput.returnKeyType = .next
        titleInput.attributedPlaceholder = NSAttributedString(
            string: titlePH, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        locationInput.layer.cornerRadius=10
        locationInput.clipsToBounds=true
        locationPH = locationInput.placeholder!
        locationInput.attributedPlaceholder = NSAttributedString(
            string: locationPH, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        mainInput.layer.cornerRadius=10
        mainInput.clipsToBounds=true
        mainInput.textContainer.maximumNumberOfLines = 5
        phoneInput.layer.cornerRadius=10
        phoneInput.clipsToBounds = true
        phonePH = phoneInput.placeholder!
        phoneInput.attributedPlaceholder = NSAttributedString(
            string: phonePH, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        if mainInput.text == nil || mainInput.text == ""{
            mainInput.text = "What Do You Offer?"
            mainInput.textColor = UIColor.lightGray
            mainInput.delegate = self
        }
        titleInput.delegate = self
        locationInput.delegate = self
        phoneInput.delegate = self

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
