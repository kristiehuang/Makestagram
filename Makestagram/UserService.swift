//
//  UserService.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/26/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserServices {
    
    
    //create new user
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        
        let userAttrs = ["username": username]
        
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    
    //reading user from database
    static func show(forUID uid: String, completion: @escaping (User?) ->Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot:snapshot)
                else {
                    return completion(nil)
            }
            completion(user)
        })
        
    }
    
    
    static func retrievePosts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let posts = snapshot.reversed().flatMap(Post.init)
            completion(posts)
        })
    }
    
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            let posts: [Post] =
                snapshot
                    .reversed()
                    .flatMap {
                        guard let post = Post(snapshot: $0)
                            else { return nil }
                        
                        //enter as sync to determine database like/nolike
                        dispatchGroup.enter()
                        
                        LikeService.isPostLiked(post) { (isLiked) in
                            post.isLiked = isLiked
                            
                            //leave
                            dispatchGroup.leave()
                            print("dispatch group run")
                        }
                        
                        return post
                }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        })
    }
        
        
        
}

