//
//  PostService.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/28/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    
    

    
    
    static func createPostStorage(for image: UIImage) {
        //create new post in STORAGE
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL
                else { return }
        let urlString = downloadURL.absoluteString
        let aspectHeight = image.aspectHeight
        createPostDatabase(forURLString: urlString, aspectHeight: aspectHeight)
        print("image url: \(urlString)")
        
        }
    }
    
    private static func createPostDatabase(forURLString urlString: String, aspectHeight: CGFloat) {
        //create new post in DATABASE
        let currentUser = User.current
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        let dict = post.dictValue
        
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        postRef.updateChildValues(dict)
    }
    
    

}
