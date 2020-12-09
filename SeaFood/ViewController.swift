//
//  ViewController.swift
//  SeaFood
//
//  Created by Nico Cobelo on 08/12/2020.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.allowsEditing = false
        
    }
    //1. Use the image that the user picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
    //2. Convert that image into a CIImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
    
    //3. Pass that CIImage into detect method
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //4. CIImage goes into the detect method
    func detect(image: CIImage) {
    
    //5. We load up our model using the Inceptionv3 model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML model failed")
        }
    
    //6. We create a request that asks the model to clasify the data and pass it
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
        
    //10. Print out the results from clasification
            print(results)
         
    //9. Once the image is clasified, this callback gets trigered and we get back a request or an error
        }
        
    //7. The passed data is defined using a handler
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
    //8. Use the image handler to perform the request of clasifying the image
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}


