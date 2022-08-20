//
//  SeePostViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 02/08/2022.
//

import UIKit

class SeePostViewController: UIViewController {

    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var namePostUIView: UIView!
    @IBOutlet weak var descriptionUIView: UIView!
    @IBOutlet weak var contactUIView: UIView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var emailTxt: UITextView!
    @IBOutlet weak var nameTxt: UITextView!
    @IBOutlet weak var locationTxt: UITextView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var post:Post?{
        didSet{
            if(nameTxt != nil){
                updateDisplay()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        postImg.layer.cornerRadius=10
        postImg.clipsToBounds=true
        namePostUIView.layer.cornerRadius=10
        namePostUIView.clipsToBounds=true
        descriptionUIView.layer.cornerRadius=10
        descriptionUIView.clipsToBounds=true
        contactUIView.layer.cornerRadius=10
        contactUIView.clipsToBounds=true
        userImg.layer.cornerRadius=10
        userImg.clipsToBounds=true
        
        if post != nil {
            updateDisplay()
        }
        else{
            stopLoading()
        }
    }
    
    func updateDisplay(){
        titleTxt.text = post?.title
        nameTxt.text = post?.username
        locationTxt.text = post?.location
        descriptionTxt.text = post?.postDescription
        
        if let url = post?.photo{
            if !url.elementsEqual("vegImg"){
                let u = URL(string:url)
                postImg.kf.setImage(with: u)
            }
            else{
                postImg.image = UIImage(named: "vegImg")
            }
        }
        
        Model.instance.getCurrentUser { currentUser in
            if currentUser != nil{
                Model.instance.getUser(byEmail: (self.post?.contactEmail)!) { user in
                    if currentUser?.email == user!.email{
                        self.editBtn.isHidden = false
                        self.deleteBtn.isHidden = false
                    }
                    self.emailTxt.text = user!.email
                    
                    if (!(user!.avatarUrl!.elementsEqual("farmerAvatarSmall"))){
                        let url = URL(string: user!.avatarUrl!)
                        self.userImg?.kf.setImage(with: url)
                    }else{
                        self.userImg.image = UIImage(named: "farmerAvatarSmall")
                    }
                    
                    self.stopLoading()
                }
            }
            else{
                self.stopLoading()
            }
        }
        
        
    }
    
}


