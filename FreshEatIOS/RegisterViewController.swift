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
        profileImage.layer.cornerRadius=40
        profileImage.clipsToBounds=true
    }
    
    @IBAction func register(_ sender: UIButton) {
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
