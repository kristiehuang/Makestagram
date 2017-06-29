//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/29/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class PostActionCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    static let height: CGFloat = 46

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        print("like button tapped")
    }
    

    
}
