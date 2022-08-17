//
//  PostTableViewCell.swift
//  FreshEatIOS
//
//  Created by Shimon Cohen on 17/08/2022.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var postUsername: UITextView!
    @IBOutlet weak var postUserPhoto: UIImageView!
    @IBOutlet weak var postTitle: UITextView!
    
    var title = "" {
        didSet{
            if(postTitle != nil){
                postTitle.text = title
            }
        }
    }
    
    var userName = "" {
        didSet{
            if(postUsername != nil){
                postUsername.text = userName
            }
        }
    }
    
    var ptPhoto = "" {
        didSet{
            if(postPhoto != nil){
                if (!ptPhoto.elementsEqual("vegImg")){
                    let url = URL(string: ptPhoto)
                    postPhoto?.kf.setImage(with: url)
                }else{
                    postPhoto.image = UIImage(named: "vegImg")
                }
            }
        }
    }
    
    
    var userPhoto = "" {
        didSet{
            if(postUserPhoto != nil){
                if (!userPhoto.elementsEqual("farmerAvatarSmall")){
                    let url = URL(string: userPhoto)
                    postUserPhoto?.kf.setImage(with: url)
                }else{
                    postUserPhoto.image = UIImage(named: "farmerAvatarSmall")
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postTitle.text = title
        postUsername.text = userName
        
        if (!userPhoto.elementsEqual("farmerAvatarSmall")){
            let url = URL(string: userPhoto)
            postUserPhoto?.kf.setImage(with: url)
        }else{
            postUserPhoto.image = UIImage(named: "farmerAvatarSmall")
        }
        
        if (!ptPhoto.elementsEqual("vegImg")){
            let url = URL(string: ptPhoto)
            postPhoto?.kf.setImage(with: url)
        }else{
            postPhoto.image = UIImage(named: "vegImg")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postUserPhoto.image = nil
        postPhoto.image = nil
     }

}
