//
//  MGPhotoHelper.swift
//  Makestagram
//
//  Created by Kristie Huang on 6/27/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {

    var completionHandler : ((UIImage) -> Void)?
    
    
    //to implement actual image picker controller
    func presentImageViewController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
        
    }
    
    
    
    func presentActionSheet(from ViewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { [unowned self] action in
                self.presentImageViewController(with: .camera, from: ViewController)

            })
            alertController.addAction(capturePhotoAction)

        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { [unowned self]action in
                self.presentImageViewController(with: .photoLibrary, from: ViewController)
        })
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        ViewController.present(alertController, animated: true)
        

        
        

        
        
    }
}

extension MGPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        picker.dismiss(animated: true)
    }
    
    //dismiss when cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
