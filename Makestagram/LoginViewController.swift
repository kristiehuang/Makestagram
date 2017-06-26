//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/23/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User
let user: FIRUser? = Auth.auth().currentUser



class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    

    @IBAction func loginButtonTapped(_ sender: Any) {
        print("loginbuttonclicked!")

        guard let authUI = FUIAuth.defaultAuthUI()
            else {
                return
        }
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated:true)
        
    }
    
    

    
    
}


extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {

//        if let error = error {
//            assertionFailure("Error signing in: \(error.localizedDescription)")
//            return
//        }
        
        guard let user = user
            else { return }
        
        let rootRef = Database.database().reference()
        let userRef = rootRef.child("users").child(user.uid)
            
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.username).")
            } else {
                print("New user!")
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        })
        
    }
}
