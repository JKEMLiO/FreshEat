//
//  PasswordChangeViewController.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 20/08/2022.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    
    @IBOutlet weak var oldPassword: DesignableUITextField!
    @IBOutlet weak var passInput: UITextField!
    @IBOutlet weak var confirmPassInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passInput.textContentType = .oneTimeCode
        confirmPassInput.textContentType = .oneTimeCode
    }
    
    
    @IBAction func changePassword(_ sender: UIButton) {
        let pass = passInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPass = confirmPassInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var fields = [String]()
        fields.append(pass)
        fields.append(confirmPass)
        
        if !Model.instance.validateFields(fields:fields){
            self.popupAlert(title: "Error Changing Password",
                            message: "You must fill in all of the fields",
                            actionTitles: ["OK"], actions: [nil])
            return
        }
        
        if !Model.instance.isValidPassword(password: pass){
            self.popupAlert(title: "Error Changing Password",
                            message: "Password MUST have minimum of 6 characters and include:\nUppercase and Lowercase letters,\na Number,\nand a Special Character",
                            actionTitles: ["OK"], actions: [nil])
            passInput.text! = ""
            confirmPassInput.text! = ""
            return
        }
        
        if pass != confirmPass{
            self.popupAlert(title: "Error Changing Password",
                            message: "Password does not match Confirm Password",
                            actionTitles: ["OK"], actions: [nil])
            confirmPassInput.text! = ""
            return
        }
        
        self.startLoading()
        Model.instance.updateUserPassword(password: pass){
            success in
            if success == true {
                print("User Password Updated")
                self.stopLoading()
                self.navigationController?.popViewController(animated: true)
            } else {
                self.stopLoading()
                self.popupAlert(title: "Error Changing Password",
                                message: "There is an issue with our server...\nPlease try again later",
                                actionTitles: ["OK"], actions: [nil])            }
        }
    }
    
}
