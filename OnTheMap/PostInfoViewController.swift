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
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var postButton: UIButton!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var textFieldUnderline: UIView!
	
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		activityIndicator.isHidden = true
	}
	
	@IBAction func onButtonPressed(_ sender: UIButton) {
		if (locationTextField?.text?.isEmpty)!  {
			Alert.showAlert(title: AlertMessages.error.rawValue, message: AlertMessages.emptyTextFieldError.rawValue, viewController: self)
		} else {
			mapString = (locationTextField?.text)!
		}
		activateIndicator(startAnimate: true, andHide: false)
		forwardGeocoding(address: mapString) { (success, error) in
			if success {
				
				DispatchQueue.main.async {
					self.activateIndicator(startAnimate: false, andHide: true)
					
					self.submitButton.isHidden = false
					self.questionLabel.text = "Enter your url"
					self.locationTextField.text = ""
					self.postButton.isHidden = true
				}
			} else {
				
				self.activateIndicator(startAnimate: false, andHide: true)
				Alert.showAlert(title: AlertMessages.error.rawValue, message: (error?.localizedDescription)!, viewController: self)
			}
		}
		

	}
	
	@IBAction func onSubmitButtonPressed(_ sender: UIButton) {
		if !(self.locationTextField.text?.isEmpty)! {
			let website = self.locationTextField?.text
			guard let location = self.location else {
				return
			}
			if let url = website {
				self.post(mapString: self.mapString, location: location, mediaURL: url)
			} else {
				self.post(mapString: self.mapString, location: location, mediaURL: "")
			}
		} else {
			Alert.showAlert(title: AlertMessages.error.rawValue, message: AlertMessages.emptyTextFieldError.rawValue, viewController: self)
		}
		
	}
	
	@IBAction func onCancelButtonPressed(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	private func forwardGeocoding(address: String, completionHandlerForGeocode: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
		CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
			if error != nil {
				completionHandlerForGeocode(false, error as? NSError)
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
			completionHandlerForGeocode(true, nil)
		})
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
							self.questionLabel.text = "Where are you studying?"
							self.locationTextField.text = ""
							self.submitButton.isHidden = true
							self.postButton.isHidden = false
							self.dismiss(animated: true, completion: nil)
						}
					}
				})
			} else {
				DispatchQueue.main.async {
					//Alert.showAlert(title: "Error", message: AlertMessages.postingError.rawValue, viewController: self)
					let alert = UIAlertController(title: AlertMessages.error.rawValue, message: AlertMessages.postingError.rawValue, preferredStyle: .alert)
					let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
						DispatchQueue.main.async {
							self.dismiss(animated: true, completion: nil)
						}
					})
					alert.addAction(dismissAction)
					let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
					
					alert.addAction(tryAgainAction)
					
					self.present(alert, animated: true, completion: nil)
				}
				
			}
		}
	}
	
	@objc private func hideKeyboard() {
		view.endEditing(true)
	}
	
	private func activateIndicator(startAnimate: Bool, andHide hidden: Bool) {
		if startAnimate {
			self.activityIndicator.startAnimating()
		} else {
			self.activityIndicator.stopAnimating()
		}
		
		self.activityIndicator.isHidden = hidden
	}
	
	
	// MARK: TextFieldDelegate Method(s)
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		locationTextField.resignFirstResponder()
		
		return true
	}

}
