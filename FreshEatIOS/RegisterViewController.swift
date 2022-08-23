//
//  RegisterViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 02/08/2022.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius=80
        profileImage.clipsToBounds=true
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor(red: 0.39216, green: 0.65490, blue: 0.26667, alpha: 1.0).cgColor
        password.textContentType = .oneTimeCode
        confirmPassword.textContentType = .oneTimeCode
        self.stopLoading()
    }
    
    @IBAction func register(_ sender: UIButton) {
        let emailAddress = email.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let fullName = name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPass = confirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var fields = [String]()
        fields.append(emailAddress)
        fields.append(fullName)
        fields.append(pass)
        fields.append(confirmPass)

        if !Model.instance.validateFields(fields:fields){
            self.popupAlert(title: "Error Signing Up",
                            message: "You must fill in all of the fields",
                            actionTitles: ["OK"], actions: [nil])
            return
        }
        
        if !Model.instance.isValidEmail(email: emailAddress){
            self.popupAlert(title: "Error Signing Up",
                            message: "Invalid Email Address",
                            actionTitles: ["OK"], actions: [nil])
            email.text! = ""
            return
        }
        
        if !Model.instance.isValidPassword(password: pass){
            self.popupAlert(title: "Error Signing Up",
                            message: "Password MUST have minimum of 6 characters and include:\nUppercase and Lowercase letters,\na Number,\nand a Special Character",
                            actionTitles: ["OK"], actions: [nil])
            password.text! = ""
            confirmPassword.text! = ""
            return
        }
        
        if pass != confirmPass{
            self.popupAlert(title: "Error Signing Up",
                            message: "Password does not match Confirm Password",
                            actionTitles: ["OK"], actions: [nil])
            confirmPassword.text! = ""
            return
        }
        
        self.isModalInPresentation = true
        self.startLoading()
        let user = User()
        user.email = emailAddress
        user.name = fullName
        
        Model.instance.isUserExists(email: user.email!) { success in
            if success{
                self.stopLoading()
                self.isModalInPresentation = false
                self.popupAlert(title: "Error Signing Up",
                                message: "Email already exists",
                                actionTitles: ["OK"], actions: [nil])
                self.email.text! = ""
                return
            }
            else{
                //User has selected image
                if let image = self.selectedImage{
                    Model.instance.uploadImage(name: emailAddress, image: image) { url in
                        user.avatarUrl = url
                        Model.instance.register(email: user.email!, password: pass) { success in
                            if success{
                                Model.instance.addUser(user: user) {
                                    self.performSegue(withIdentifier: "toHomeScreenSegue", sender: self)
                                }
                            }
                            else{
                                self.isModalInPresentation = false
                                self.stopLoading()
                                self.popupAlert(title: "Error Signing Up",
                                                message: "There is an issue with our server...\nPlease try again later",
                                                actionTitles: ["OK"], actions: [nil])
                            }
                        }
                    }
                }
                //User hasn't selected image - using default avatar image
                else{
                    user.avatarUrl = "farmerAvatarSmall"
                    Model.instance.register(email: user.email!, password: pass) { success in
                        if success{
                            Model.instance.addUser(user: user) {
                                self.performSegue(withIdentifier: "toHomeScreenSegue", sender: self)
                            }
                        }
                        else{
                            self.isModalInPresentation = false
                            self.stopLoading()
                            self.popupAlert(title: "Error Signing Up",
                                            message: "There is an issue with our server...\nPlease try again later",
                                            actionTitles: ["OK"], actions: [nil])
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
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
    
    var selectedImage: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage
        self.profileImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    

}
