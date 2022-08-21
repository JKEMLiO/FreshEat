//
//  SplashViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 20/08/2022.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let splashGif = UIImage.gifImageWithName("splash2")
        imageView.image = splashGif
        let seconds = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            Model.instance.isUserLoggedIn { email in
                if email != nil {
                Model.instance.isUserExists(email: email!) { success in
                    if !success{
                        Model.instance.signOut { success in
                            print("Logout successfully - Navigating to Welcome Screen")
                            self.performSegue(withIdentifier: "toWelcomeSegue", sender: nil)
                        }
                    }
                    else{
                        self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
                       }
                    }
                }
                else{
                    self.performSegue(withIdentifier: "toWelcomeSegue", sender: nil)
                }
            }
        }
    }
    
}
