//
//  PostInfoViewController.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 2/1/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import UIKit
import MapKit

class PostInfoViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var questionLabel: UILabel!
	
	private var mapString: String = ""
	private var location: CLLocation?
	private var url: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
		locationTextField.delegate = self
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		view.addGestureRecognizer(tap)
    }

	@objc private func hideKeyboard() {
		view.endEditing(true)
	}
	
	private func post(mapString: String, location: CLLocation, mediaURL: String?) {
		guard let mediaURL = mediaURL else {
			return
		}
		let body: [String: AnyObject] = ["uniqueKey": UdacityClient.sharedInstance().idKey! as AnyObject,
					"firstName": UdacityClient.sharedInstance().firstName! as AnyObject,
					"lastName": UdacityClient.sharedInstance().lastName! as AnyObject,
					"mapString": mapString as AnyObject,
					"mediaURL": mediaURL as AnyObject,
					"latitude": location.coordinate.latitude as AnyObject,
					"longitude": location.coordinate.longitude as AnyObject]
		
		let _ = ParseClient.sharedInstance().taskForPostMethod(method: nil, body: body) { (success, error) in
			if success {
				ParseClient.sharedInstance().getStudentLocations(completionHandlerForStudents: { (results, success, error) in
					if success {
						DispatchQueue.main.async {
							self.dismiss(animated: true, completion: nil)
						}
					}
				})
			} else {
				Alert.showAlert(title: "Error", message: AlertMessages.postingError.rawValue, viewController: self)
			}
		}
	}
    

	
	@IBAction func onButtonPressed(_ sender: UIButton) {
		if sender.title(for: .normal) == "Find" {
			if !(locationTextField.text?.isEmpty)! {
				mapString = (locationTextField?.text)!
				forwardGeocoding(address: mapString)
				
				sender.setTitle("Submit", for: .normal)
				questionLabel.text = "Enter your url"
				locationTextField.text = ""
			}
			
		} else {
			if !(locationTextField.text?.isEmpty)! {
				let website = locationTextField?.text
				guard let location = location else {
					return
				}
				if let url = website {
					post(mapString: mapString, location: location, mediaURL: url)
				} else {
					post(mapString: mapString, location: location, mediaURL: "")
				}
				
			}
			sender.setTitle("Find", for: .normal)
			questionLabel.text = "Where are you studying?"
			locationTextField.text = ""
		}
	}

	@IBAction func onCancelButtonPressed(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	private func forwardGeocoding(address: String) {
		CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
			if error != nil {
				print(error!)
				return
			}
			
			guard let placemarks = placemarks else {
				return
			}
			if placemarks.count > 0 {
				let placemark = placemarks[0]
				self.location = placemark.location!
				guard let coordinate = self.location?.coordinate else {
					return
				}
				let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
				let annotation = MKPointAnnotation()
				annotation.coordinate = coordinate
				DispatchQueue.main.async {
					self.mapView.addAnnotation(annotation)
					self.mapView.setRegion(region, animated: true)
				}
			}
		})
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		locationTextField.resignFirstResponder()
		
		return true
	}
}
