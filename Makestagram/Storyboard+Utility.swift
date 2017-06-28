   //
//  Storyboard+Utility.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/27/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    enum MakestaType: String {
        case login
        case main
        
        var filename: String {
            return rawValue.capitalized
        }
 
        
    }
    
    
    
    //initialize correct storyboard
    convenience init(type: MakestaType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    
    static func initialViewController(for type: MakestaType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController()
            else {
                fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
            }
        
        return initialViewController
    }
    
    
    
}
