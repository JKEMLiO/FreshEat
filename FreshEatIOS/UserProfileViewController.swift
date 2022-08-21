//
//  UserProfileViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 13/08/2022.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius=100
        profileImage.clipsToBounds=true
        self.startLoading()
        Model.instance.getCurrentUser { user in
            if user != nil{
                self.email.text = user!.email
                self.name.text = user!.name
                if (!user!.avatarUrl!.elementsEqual("farmerAvatarSmall")){
                    let url = URL(string: user!.avatarUrl!)
                    self.profileImage?.kf.setImage(with: url,completionHandler: { result in
                        self.stopLoading()
                    })
                }else{
                    self.profileImage.image = UIImage(named: "farmerAvatarSmall")
                    self.stopLoading()
                }
            }
            else{
                self.stopLoading()
            }
        }
    }
    
}
