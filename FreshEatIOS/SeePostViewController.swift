//
//  SeePostViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 02/08/2022.
//

import UIKit
import SkeletonView

class SeePostViewController: UIViewController {

    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var namePostUIView: UIView!
    @IBOutlet weak var descriptionUIView: UIView!
    @IBOutlet weak var contactUIView: UIView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var emailTxt: SMIconLabel!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var locationTxt: UILabel!
    @IBOutlet weak var descriptionTxt: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var phoneTxt: SMIconLabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var post:Post?{
        didSet{
            if(nameTxt != nil){
                updateDisplay()
                stopSkel()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImg.layer.cornerRadius=10
        postImg.clipsToBounds=true
        namePostUIView.layer.cornerRadius=10
        namePostUIView.clipsToBounds=true
        descriptionUIView.layer.cornerRadius=10
        descriptionUIView.clipsToBounds=true
        contactUIView.layer.cornerRadius=10
        contactUIView.clipsToBounds=true
        userImg.layer.cornerRadius=20
        userImg.clipsToBounds=true
        descriptionTxt.sizeToFit()
        let topAlignment: SMIconLabel.VerticalPosition = .top
        emailTxt.icon = UIImage(systemName: "mail")
        emailTxt.iconPadding = 5
        emailTxt.numberOfLines = 0
        emailTxt.iconPosition = ( .left, topAlignment )
        emailTxt.textAlignment = .left
        phoneTxt.icon = UIImage(systemName: "phone")
        phoneTxt.iconPadding = 5
        phoneTxt.numberOfLines = 0
        phoneTxt.iconPosition = ( .left, topAlignment )
        phoneTxt.textAlignment = .left
        skelShow()
        startLoading()
        
        
        if post != nil {
            updateDisplay()
        }
        else{
            stopLoading()
            stopSkel()
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
                        self.editBtn.isEnabled = true
                        self.deleteBtn.isEnabled = true
                    }
                    self.emailTxt.text = user!.email
                    
                    if (!(user!.avatarUrl!.elementsEqual("farmerAvatarSmall"))){
                        let url = URL(string: user!.avatarUrl!)
                        self.userImg?.kf.setImage(with: url)
                    }else{
                        self.userImg.image = UIImage(named: "farmerAvatarSmall")
                    }
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
    
    
    @IBAction func deletePost(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] UIAlertAction in
            self.delPost()
        }))
                                      
        present(alert, animated: true, completion: nil)
    }
    
    func skelShow(){
        self.view.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
    }
    
    func stopSkel(){
        self.view.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
    }
    
    func delPost(){
        self.startLoading()
        Model.instance.deletePost(post: post!) {
            self.stopLoading()
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
    @IBAction func editPost(_ sender: Any) {
        performSegue(withIdentifier: "openEditPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openEditPost"){
            let dvc = segue.destination as! EditPostViewController
            dvc.post = self.post
            }
    }
    
    
}


