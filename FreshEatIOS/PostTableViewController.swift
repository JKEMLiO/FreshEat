//
//  PostTableViewController.swift
//  FreshEatIOS
//
//  Created by csuser on 02/08/2022.
//

import UIKit

class PostTableViewController: UITableViewController {
    
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
        Model.instance.getAllPosts(){
            posts in
            self.data = posts
            self.data.sort(by: { $0.lastUpdated > $1.lastUpdated })
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openPostCell"){
            let dvc = segue.destination as! SeePostViewController
            let pt = data[selectedRow]
            dvc.post = pt
        }
    }

}
