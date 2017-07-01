//
//  LikeService.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/29/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct LikeService {
    
    
    
    static func createLike(for post: Post, success: @escaping (Bool) -> Void) {
        //post must have a key
        guard let key = post.key
            else {
                return success(false)
        }
        
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount + 1
                
                return TransactionResult.success(withValue: mutableData)
            },
                                             andCompletionBlock: { (error, _, _) in
                                                if let error = error {
                                                    assertionFailure(error.localizedDescription)
                                                    success(false)
                                                } else { success(true) }
            })
        }
        
    }
    
    
    
    static func deleteLike(for post: Post, success: @escaping (Bool) -> Void) {
        guard let key = post.key
            else {
                return success(false)
        }
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        likesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0

                mutableData.value = currentCount - 1
                return TransactionResult.success(withValue: mutableData)
            },
                                             andCompletionBlock: {(error, _, _) in
                                                if let error = error {
                                                    assertionFailure(error.localizedDescription)
                                                    success(false)
                                                }
                                                else { success(true) }
            })
            
        }
        
    }
    
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key")
            return completion(false)
        }
        let likesRef = Database.database().reference().child("postsLikes").child(postKey)
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            }
            else { completion(false) }
        })
    }
    
    static func setIsLiked(_ isLiked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
        if isLiked {
            createLike(for: post, success: success)
            print("liked")
        } else {
            deleteLike(for: post, success: success)
            print("unliked")
        }
    }
    
}
