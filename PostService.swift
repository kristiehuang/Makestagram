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
        
        let roofRef = Database.database().reference()
        let newPostRef = roofRef.child("posts").child(currentUser.uid).childByAutoId()
        let newPostKey = newPostRef.key
        
        UserServices.followers(for: currentUser) { (followerUIDs) in
            let timelinePostDict = ["poster_uid" : currentUser.uid]
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]
            
            for uid in followerUIDs {
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
            }
            
            let postDict = dict
            updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict
            
            roofRef.updateChildValues(updatedData)
            
        }
    }
    
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child(posterUID).child(postKey)
        
        print("show func run")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })
    }
    
    

}
