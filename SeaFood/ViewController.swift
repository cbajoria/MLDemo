//
//  ViewController.swift
//  SeaFood
//
//  Created by Chandrika Bajoria on 12/10/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imagePicked: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
      {
        imagePicked.image = userPickedImage
        
        guard let ciimage = CIImage(image: userPickedImage) else {
            fatalError("cannot convert into ciimage ")
        }
        detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func  detect(image : CIImage)  {
      
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("could not create ML model")
        }
      
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result =  request.results as? [VNClassificationObservation] else
            {
                fatalError("failed to procees image")
            }
           
            if let firstResult = result.first
            {
                
                    self.navigationItem.title = firstResult.identifier.description
                
            }
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        }catch{}
    }
    
    
    @IBAction func cameraClicked(_ sender: UIBarButtonItem) {
    
        present(imagePicker, animated: true, completion: nil)
    }
    

}

