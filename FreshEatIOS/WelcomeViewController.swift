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
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn"){
            if let email = UserDefaults.standard.string(forKey: "email"){
                Model.instance.isUserExists(email: email) { success in
                    if !success{
                        Model.instance.signOut { success in
                            print("Logout successfully - Navigating to Welcome Screen")
                        }
                    }
                    else{
                        Model.instance.isUserLoggedIn(){
                           success in
                           if success{
                               self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
                           }else{
                               Model.instance.signOut { success in
                                   print("Logout successfully - Navigating to Welcome Screen")
                               }
                           }
                       }
                    }
                }
            }
            else{
                Model.instance.signOut { success in
                    print("Logout successfully - Navigating to Welcome Screen")
                }
            }
        }
    }
    

}

