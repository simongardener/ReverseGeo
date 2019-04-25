//
//  ViewController.swift
//  ReverseGeo
//
//  Created by Simon Gardener on 06/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var latAndLongTextField: UITextField!
    @IBOutlet weak var reverseGeoResult: UILabel!
    let latitudeRange = -89.9999...89.9999
    let longitudeRange = -179.9999...179.99999
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func reverseFromClipboardTapped(_ sender: UIButton) {
        latAndLongTextField.resignFirstResponder()
        guard let location = extractLocationfromPasteboard() else { return }
        reverseGeoFor(location)
    }
    
    @IBAction func reverseFromTextTapped(_ sender: UIButton) {
        latAndLongTextField.resignFirstResponder()
        startGeoFromTextField()
    }
    func startGeoFromTextField(){
        guard let location = extractLocationfromTextField() else { return }
        reverseGeoFor(location)
    }
    func extractLocationfromPasteboard()-> CLLocation? {
        let pasteboard = UIPasteboard.general
        guard let locationString = pasteboard.string, locationString.isEmpty == false   else {
            displayInvalidInput()
            return nil}
        latAndLongTextField.text = locationString
        return getLocation(from: locationString)
    }
    
    func extractLocationfromTextField()-> CLLocation? {
        guard let locationString = latAndLongTextField.text, locationString.isEmpty == false else {
            displayInvalidInput()
            return nil
        }
        
        return getLocation(from: locationString)
    }
    
    func getLocation(from locationString: String) -> CLLocation? {
        let spaceandtabset  = CharacterSet.init(charactersIn: " \t")
        var elements  = locationString.components(separatedBy: spaceandtabset)
        elements = elements.filter {$0 != ""}
        
        guard elements.count == 2 else {
            displayInvalidInput()
            return nil
        }
        reverseGeoResult.text = elements.joined(separator: "\n")
        guard let latitude = Double(elements[0]), let longitude = Double(elements[1]) else {
            displayInvalidInput()
            return nil
        }
        guard latitudeRange.contains(latitude) && longitudeRange.contains(longitude) else {
            displayInvalidInput()
            return nil
        }
        return CLLocation.init(latitude: latitude, longitude: longitude)
    }
    func reverseGeoFor(_ location: CLLocation) {
        let myGeocoder = CLGeocoder()
        
        myGeocoder.reverseGeocodeLocation(location){ (placemark, error) in
            if error != nil {
                print("Error, \(String(describing: error ))")
            }
            
            if let place = placemark?.first {
                let placedata  = """
                country: \(place.country ?? "_")
                isocode: \(place.isoCountryCode ?? "_")
                state: \(place.administrativeArea ?? "_")
                subadmin :\(place.subAdministrativeArea ?? "_")
                locality :\(place.locality  ?? "_")
                sublocality :\(place.subLocality  ?? "_")
                bodyOfWater :\(place.ocean ?? place.inlandWater ?? "_")
                """
                
                self.reverseGeoResult.text = placedata
                
                let pasteboard = UIPasteboard.general
                pasteboard.string = placedata
            }
        }
    }
    
    func displayInvalidInput() {
        reverseGeoResult.text = "Invalid Input .\n\nInput should be 2 decimal numbers separated by a space or spaces. \n\nNo leters or symbols allowed.\n\n Latitude should be first.\n\n Latitude <90 >-90\n\nlongitude<180 > -180"
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        startGeoFromTextField()
    }
}
