//
//  EditPostViewController.swift
//  FreshEatIOS
//
//  Created by Emil Kollek on 21/08/2022.
//

import UIKit
import SkeletonView

class EditPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    

    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var mainTxt: UITextView!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var postImg: UIImageView!
    
    var post:Post?{
       didSet{
           if(titleTxt != nil){
               updateDisplay()
           }
       }
   }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTxt.layer.cornerRadius=10
        titleTxt.clipsToBounds = true
        mainTxt.layer.cornerRadius = 10
        mainTxt.clipsToBounds = true
        locationTxt.layer.cornerRadius = 10
        locationTxt.clipsToBounds = true
        phoneTxt.layer.cornerRadius = 10
        phoneTxt.clipsToBounds = true
        postImg.layer.cornerRadius = 10
        postImg.clipsToBounds = true
        
        if post != nil{
            updateDisplay()
        }
        
    }
    
    func updateDisplay(){
        self.startLoading()
        self.skelShow()
        
        titleTxt.text = post?.title
        mainTxt.text = post?.postDescription
        locationTxt.text = post?.location
        phoneTxt.text = post?.contactPhone
        
        if let urlStr = post?.photo {
            if (!urlStr.elementsEqual("vegImg")){
                let url = URL(string: urlStr)
                postImg?.kf.setImage(with: url,completionHandler: { result in
                    self.stopSkel()
                    self.stopLoading()
                })
            }else{
                postImg.image = UIImage(named: "vegImg")
                self.stopSkel()
                self.stopLoading()
            }
        }
    }
    
    func skelShow(){
        self.view.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
    }
    
    func stopSkel(){
        self.view.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentTxt = textField.text ?? ""
        guard let stringRange = Range(range, in: currentTxt) else {
            return false
        }
        
        let updateText = currentTxt.replacingCharacters(in: stringRange, with: string)
        return updateText.count < 30
    
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentTxt = textView.text ?? ""
        guard let textRange = Range(range, in: currentTxt) else {
            return false
        }
        
        let updateText = currentTxt.replacingCharacters(in: textRange, with: text)
        return updateText.count < 200
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What Do You Offer?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    

    @IBAction func restoreBtn(_ sender: Any) {
    }
    
    @IBAction func changeImgBtn(_ sender: Any) {
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
    }
}
