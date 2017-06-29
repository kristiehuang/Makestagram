//
//  MainTabBarController.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/27/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    
    let photoHelper = MGPhotoHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            PostService.createPostStorage(for: image)
        }
 
        delegate = self
        tabBar.unselectedItemTintColor = .black
    }
    
    
    
}



extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
                if viewController.tabBarItem.tag == 1 {
        
                    //show phototaking action
                    
                    photoHelper.presentActionSheet(from: self)
                    return false
        
                } else {
                    return true
                }
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        
//        if viewController.tabBarItem.tag == 1 {
//            
//            //show phototaking action
//            print("take photo")
//            return false
//            
//        } else {
//            return true
//        }
//    }
}
