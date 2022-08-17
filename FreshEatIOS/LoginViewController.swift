//
//  ViewController.swift
//  FreshEatIOS
//
//  Created by Emil Kollek on 15/06/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.textContentType = .oneTimeCode
        self.stopLoading()
    }
    
    @IBAction func login(_ sender: UIButton) {
        let emailAddress = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var fields = [String]()
        fields.append(emailAddress)
        fields.append(pass)
        
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
        
        self.isModalInPresentation = true
        self.startLoading()
        
        Model.instance.signIn(email: emailAddress, password: pass) { success in
            if success{
                self.performSegue(withIdentifier: "toHomeScreenSegue", sender: self)
            }
            else{
                self.isModalInPresentation = false
                self.stopLoading()
                self.popupAlert(title: "Failed to sign in",
                                message: "Email or password is incorrect",
                                actionTitles: ["OK"], actions: [nil])
                self.email.text! = ""
                self.password.text! = ""
            }
        }
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
