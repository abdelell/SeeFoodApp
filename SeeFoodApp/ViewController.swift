//
//  ViewController.swift
//  SeeFoodApp
//
//  Created by macbook on 11/19/18.
//  Copyright © 2018 Abdel. All rights reserved.
//

import UIKit
import VisualRecognitionV3


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    
    let apiKey = "API_KEY"
    let version = "2018-11-19"
    
    let imagePicker = UIImagePickerController()
    var classificationResults : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            
            let imageData = image.jpegData(compressionQuality: 0.01)
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
            
            try? imageData?.write(to: fileURL, options: [])
            
            visualRecognition.classify(imagesFile: fileURL, url: nil, threshold: nil, owners: nil, classifierIDs: nil, acceptLanguage: nil, headers: nil, failure: nil, success: { (classifiedImages) in
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                
                self.classificationResults = []
                
                for index in 1..<classes.count{
                    self.classificationResults.append(classes[index].className)
                }
                
                print(self.classificationResults)
                
                if self.classificationResults.contains("sandwich") {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Sandwich!"
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not a Sandwich!"
                    }
                }
            })

        } else {
            print("there is an error picking an image")
        }
        
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

