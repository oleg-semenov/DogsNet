//
//  ViewController.swift
//  Dogs
//
//  Created by Oleg Semenov on 9/16/18.
//  Copyright © 2018 Ole. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var predictionText: UITextView!
    
    let model = mobilenet_1_0_224_dogs_1()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func chooseDogImage(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Dog Image Source", message: "Choose a source", preferredStyle: .actionSheet)
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let noCameraAlert = UIAlertController(title: "Camera not avaliable", message: nil, preferredStyle: .alert)
                noCameraAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(noCameraAlert, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dogImageView.image = image
        picker.dismiss(animated: true, completion: nil)
        predict(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func predict(image: UIImage) {
        if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image) {
            let res = try! model.prediction(input__0: pixelBuffer)
            predictionText.text = top7Predictions(allPredictions: res.final_result__0).description
        }
    }
    
    func top7Predictions(allPredictions: [String : Double]) -> ContiguousArray<(String, Double)> {
        var res = ContiguousArray<(String, Double)>()
        res.reserveCapacity(7)
        var lastMaxScore = Double.infinity
        var lastMaxLabel: String = ""
        for _ in 1...7 {
            var maxScore = -1.0
            var maxLabel: String = ""
            for (label, score) in allPredictions {
                if score > maxScore && score <= lastMaxScore && label != lastMaxLabel {
                    maxScore = score
                    maxLabel = label
                }
            }
            lastMaxScore = maxScore
            lastMaxLabel = maxLabel
            res.append((maxLabel, maxScore))
        }
        return res
    }
}

