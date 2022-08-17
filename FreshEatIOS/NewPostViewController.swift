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
    @IBOutlet weak var mainInput: UITextView!
    @IBOutlet weak var imgPost: UIImageView!
    var titlePH = ""
    var locationPH = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPost.layer.cornerRadius=15
        imgPost.clipsToBounds=true
        titleInput.layer.cornerRadius=10
        titleInput.clipsToBounds=true
        titlePH = titleInput.placeholder!
        titleInput.returnKeyType = .next
        locationInput.layer.cornerRadius=10
        locationInput.clipsToBounds=true
        locationPH = locationInput.placeholder!
        mainInput.layer.cornerRadius=10
        mainInput.clipsToBounds=true
        mainInput.text = "What Do You Offer?"
        mainInput.textColor = UIColor.lightGray
        mainInput.delegate = self
        titleInput.delegate = self
        locationInput.delegate = self
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
        
                
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//            textField.placeholder = ""
//            textField.textColor=UIColor.black
//            return true
//
//     }
    
    func textFieldDidBeginEditing(_ textField:UITextField){
        textField.placeholder=""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((titleInput.text?.isEmpty) != nil){
            titleInput.placeholder = titlePH
        }
        if ((locationInput.text?.isEmpty) != nil){
            locationInput.placeholder = locationPH
        }
    }
    
    
    @IBAction func uploadImage(_ sender: UIButton) {
        takePicture(source: .photoLibrary)
    }
    
    @IBAction func uploadPost(_ sender: UIButton) {
        
        let title = titleInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = mainInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let location = locationInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // Add let phone = phoneInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var fields = [String]()
        fields.append(title)
        fields.append(description)
        fields.append(location)
        
        if !Model.instance.validateFields(fields: fields){
            self.popupAlert(title: "Error Signing Up",
                            message: "You must fill in all of the fields",
                            actionTitles: ["OK"], actions: [nil])
            return
        }
        
        self.startLoading()
        let post = Post()
        post.id = UUID().uuidString
        post.title = title
        post.postDescription = description
        post.location = location
        post.isPostDeleted = false
        // Add post.contactPhone = phone
        Model.instance.getCurrentUser { user in
            if user != nil {
                post.username = user?.name
                post.contactEmail = user?.email
            }
            
            //User has selected image
            if let image = self.selectedImage{
                Model.instance.uploadImage(name: post.id!, image: image) { url in
                    post.photo = url
                }
            }
            //User hasn't selected image
            else{

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
        
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        self.imgPost.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
