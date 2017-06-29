//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/27/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var posts:[Post] = []
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()
        
        UserServices.retrievePosts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }

}

//setup table to retrieve data from Post array
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]

        
        switch indexPath.row {
        case 0:
            //header
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.usernameLabel.text = User.current.username
            
            return cell

        case 1:
            //phoot
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell", for: indexPath) as! PostActionCell
            //time ago label
            cell.timeStampLabel.text = timestampFormatter.string(from: post.creationDate)
            
            return cell

        default:
            fatalError("error: unexpected indexPath")
        }
        
    }
    
    
    func configureTableView() {
        //remove separators for empty and all cells
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
        case 2:
            return PostActionCell.height
        default:
            fatalError()
        }

    }
}
