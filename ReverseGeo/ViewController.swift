//
//  ViewController.swift
//  ReverseGeo
//
//  Created by Simon Gardener on 06/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var latAndLongTextField: UITextField!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var reverseGeoResult: UITextView!
    
    @IBAction func startGeo(_ sender: UIButton) {
        print("in start geo")
        latAndLongTextField.resignFirstResponder()
        guard let coordinates = extractLatAndLong() else { return }
        print("coordinate = \(coordinates)")
    }
    
    func extractLatAndLong()-> (latitude: Double, longitude:Double)? {
        guard let locationString = latAndLongTextField.text, locationString.isEmpty == false else {
            invalidInput()
            return nil
        }
        let spaceandtabset  = CharacterSet.init(charactersIn: " \t")
        var elements  = locationString.components(separatedBy: spaceandtabset)
        elements = elements.filter {$0 != ""}
        
        guard elements.count == 2 else {
            invalidInput()
            return nil
        }
        reverseGeoResult.text = elements.joined(separator: "\n")
        guard let latitude = Double(elements[0]), let longitude = Double(elements[1]) else {
            invalidInput()
            return nil
        }
        latitudeLabel.text = elements[0]
        longitudeLabel.text = elements[1]
        return (latitude, longitude)
    }
    func invalidInput() {
        reverseGeoResult.text = "Invalid Input .\n\nInput should be 2 decimal numbers separated by a space or spaces. \n\nNo leters or symbols allowed.\n\n Latitude should be first."
    }
}

