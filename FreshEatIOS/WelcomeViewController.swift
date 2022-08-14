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
        
        Model.instance.isUserLoggedIn(){
           success in
           if success{
               self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
           }
       }
    }
    
    @IBAction func backFromRegister (segue:UIStoryboardSegue){
        
    }


}

