//
//  PostTableViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 02/08/2022.
//

import UIKit
import SkeletonView

class PostTableViewController: UITableViewController, SkeletonTableViewDataSource {
    
    var data = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:
                                              #selector(reload),
                                              for: .valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString("Loading Posts...")
        
        
        Model.postDataNotification.observe {
            self.reload()
        }
        
        reload()
        
    }
        
    @objc func reload(){
        if self.refreshControl?.isRefreshing == false {
            self.refreshControl?.beginRefreshing()
        }
        self.tableView.contentOffset = CGPoint(x:0,y:-90)
        self.tableView.isSkeletonable = true
        self.tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
        Model.instance.getAllPosts(){
            posts in
            self.data = posts
            self.data.sort(by: { $0.lastUpdated > $1.lastUpdated })
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { UIAlertAction in
            self.logout()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func logout(){
        Model.instance.signOut { success in
            if success{
                let welcomeVC = self.storyboard?.instantiateViewController(identifier: "welcomeVC")
                welcomeVC?.modalPresentationStyle = .fullScreen
                self.present(welcomeVC!, animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: false)
                    self.tabBarController?.selectedIndex = 0
                })
            }
            else{
                self.popupAlert(title: "Error", message: "There was an issue logging out", actionTitles: ["OK"], actions: [nil])
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
      

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        let pt = data[indexPath.row]
        cell.title = pt.title!
        cell.userName = pt.username!
        cell.ptPhoto = pt.photo!
        cell.viewBackground.layer.cornerRadius=10
        cell.viewBackground.clipsToBounds=true
        
        Model.instance.getCurrentUser { user in
            if user != nil{
                if user?.email == pt.contactEmail{
                    cell.editIcon.isHidden = false
                    cell.editIcon.isUserInteractionEnabled = true
                }
            }
        }
        
        Model.instance.getUser(byEmail: pt.contactEmail!) { user in
            if user != nil{
                cell.userPhoto = (user?.avatarUrl!)!
            }
        }
        
        return cell
    }
    
    var selectedRow = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Selcted row is: \(indexPath.row)")
        selectedRow = indexPath.row
        performSegue(withIdentifier: "openPostCell", sender: self)
        
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "postCell"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openPostCell"){
            let dvc = segue.destination as! SeePostViewController
            let pt = data[selectedRow]
            dvc.post = pt
        }
    }

}
