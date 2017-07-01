//
//  FindFriendsCell.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/30/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

protocol FindFriendsCellDelegate:class {
    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell)
}

class FindFriendsCell: UITableViewCell {
    
    weak var delegate: FindFriendsCellDelegate?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func followButton(_ sender: UIButton) {
        delegate?.didTapFollowButton(sender, on: self)
        print("follow button tapped")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 6
        followButton.clipsToBounds = true
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)

    }
}
