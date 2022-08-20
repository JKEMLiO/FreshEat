//
//  UserProfileViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 13/08/2022.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius=100
        profileImage.clipsToBounds=true
    }
    


}
