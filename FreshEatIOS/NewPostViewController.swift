//
//  NewPostViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 02/08/2022.
//

import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
