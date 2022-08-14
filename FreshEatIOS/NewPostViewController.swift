//
//  NewPostViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 02/08/2022.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var mainInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var imgPost: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPost.layer.cornerRadius=15
        imgPost.clipsToBounds=true
        titleInput.layer.cornerRadius=10
        titleInput.clipsToBounds=true
        locationInput.layer.cornerRadius=10
        locationInput.clipsToBounds=true
        mainInput.layer.cornerRadius=10
        mainInput.clipsToBounds=true
        
        mainInput.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor).isActive = true
        mainInput.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor).isActive = true
        

        
        

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
