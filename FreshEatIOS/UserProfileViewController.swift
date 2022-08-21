//
//  UserProfileViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 13/08/2022.
//

import UIKit
import SkeletonView

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius=100
        profileImage.clipsToBounds=true
        self.view.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
        self.startLoading()
        Model.instance.getCurrentUser { user in
            if user != nil{
                self.email.text = user!.email
                self.name.text = user!.name
                if (!user!.avatarUrl!.elementsEqual("farmerAvatarSmall")){
                    let url = URL(string: user!.avatarUrl!)
                    self.profileImage?.kf.setImage(with: url,completionHandler: { result in
                        self.stopSkel()
                        self.stopLoading()
                    })
                }else{
                    self.profileImage.image = UIImage(named: "farmerAvatarSmall")
                    self.stopSkel()
                    self.stopLoading()
                }
            }
            else{
                self.stopSkel()
                self.stopLoading()
            }
        }
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
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
        self.startLoading()
        self.profileImage.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
        if let image = selectedImage{
            Model.instance.uploadImage(name: self.email.text!, image: image) { url in
                Model.instance.getCurrentUser { user in
                    Model.instance.editUser(user: user!, data: ["avatarUrl":url]) {
                        Model.postDataNotification.post()
                        self.stopSkel()
                        self.stopLoading()
                    }
                }
            }
        }

    }
    
    func stopSkel(){
        self.view.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
    }
    
}
