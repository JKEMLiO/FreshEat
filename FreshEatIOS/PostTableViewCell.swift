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
    @IBOutlet weak var postUserPhoto: UIImageView!
    @IBOutlet weak var postUsername: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var editIcon: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    
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
                postPhoto.layer.cornerRadius=25
                postPhoto.clipsToBounds = true
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
                postUserPhoto.layer.cornerRadius=25
                postUserPhoto.clipsToBounds = true
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postUserPhoto.image = nil
        postPhoto.image = nil
        editIcon.isHidden = true
     }

}
