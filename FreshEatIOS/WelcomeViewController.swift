//
//  ViewController.swift
//  FreshEatIOS
//
//  Created by Emil Kollek on 15/06/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let seconds = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            Model.instance.isUserLoggedIn { email in
                if email != nil {
                Model.instance.isUserExists(email: email!) { success in
                    if !success{
                        Model.instance.signOut { success in
                            print("Logout successfully - Navigating to Welcome Screen")
                        }
                    }
                    else{
                        self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
                       }
                    }
                }
            }
        }
    }
}



