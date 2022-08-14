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
        profileImage.layer.cornerRadius=100
        profileImage.clipsToBounds=true
    }
    
    @IBAction func register(_ sender: UIButton) {
        let emailAddress = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let fullName = name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPass = confirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var fields = [String]()
        fields.append(emailAddress)
        fields.append(fullName)
        fields.append(pass)
        fields.append(confirmPass)

        if !validateFields(fields:fields){
            self.alert(title:"Error Signing Up",msg:"You must fill in all of the fields")
            return
        }
        
        if !Model.instance.isValidEmail(email: emailAddress){
            self.alert(title:"Error Signing Up",msg:"Invalid Email Address")
            email.text! = ""
            return
        }
        
        if !Model.instance.isValidPassword(password: pass){
            self.alert(title:"Error Signing Up",msg:"Password MUST have minimum of 6 characters and include:\nUppercase and Lowercase letters,\na Number,\nand a Special Character")
            password.text! = ""
            confirmPassword.text! = ""
            return
        }
        
        if pass != confirmPass{
            self.alert(title:"Error Signing Up",msg:"Password does not match Confirm Password")
            confirmPassword.text! = ""
            return
        }
        
        let user = User()
        user.email = emailAddress
        user.name = fullName
        
        Model.instance.isUserExists(email: user.email!) { success in
            if success{
                self.alert(title: "Failed to Sign Up", msg: "Email already exists")
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
                        }
                    }
                }
                //User hasn't selected image - using default avatar image
                else{
                    user.avatarUrl = "farmerAvatar"
                    Model.instance.register(email: user.email!, password: pass) { success in
                        if success{
                            Model.instance.addUser(user: user) {
                                self.performSegue(withIdentifier: "toHomeScreenSegue", sender: self)
                            }
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
        
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        self.profileImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateFields(fields: [String]) ->Bool{
        for field in fields{
            if field == ""{
                return false
            }
        }
        return true
    }
    
    func alert(title:String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
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
