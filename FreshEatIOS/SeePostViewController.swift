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
    @IBOutlet weak var emailTxt: UITextView!
    @IBOutlet weak var userImg: UIImageView!
    
    var post:Post?{
        didSet{
            if(namePostUIView != nil){
                updateDisplay()
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
        userImg.layer.cornerRadius=10
        userImg.clipsToBounds=true
        
        if post != nil {
            updateDisplay()
        }
    }
    
    func updateDisplay(){
        
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


