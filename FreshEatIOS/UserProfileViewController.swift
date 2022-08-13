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
        profileImage.layer.cornerRadius=40
        profileImage.clipsToBounds=true

        // Do any additional setup after loading the view.
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
