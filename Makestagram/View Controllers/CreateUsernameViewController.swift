//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/26/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func usernameTextField(_ sender: Any) {
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print("next button tapped!")
        
        guard let firUser = Auth.auth().currentUser, let username = usernameTextField.text, !username.isEmpty else { return }
        
        UserServices.create(firUser, username: username)  {
            (user) in
            guard let _ = user
            else {
                return
            }
            
            User.setCurrent(user!)
            print("created new user")
            
            
            //before refactoring
//            let storyboard = UIStoryboard(name: "Main", bundle: .main)
//            
//            if let initialViewController = storyboard.instantiateInitialViewController() {
//                self.view.window?.rootViewController = initialViewController
//                self.view.window?.makeKeyAndVisible()
//            }
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
    
    
        }

    }

}
