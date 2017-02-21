//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/25/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

	@IBOutlet weak var mapView: MKMapView!
	
	private var annotations = [StudentAnnotation]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		mapView.delegate = self
    }

	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		getStudentLocations()
	}
	
	// MARK: IBAction(s)
	
	@IBAction func onPinButtonPressed(_ sender: UIButton) {
		let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoVC") as! PostInfoViewController
		present(infoVC, animated: true, completion: nil)
		
	}
	
	@IBAction func onRefreshButtonPressed(_ sender: UIButton) {
		getStudentLocations()
	}
	
	@IBAction func onLogoutButtonPressed(_ sender: UIButton) {
		UdacityClient.sharedInstance().logOut { (success, error) in
			if success {
				self.dismiss(animated: true, completion: nil)
			}
		}
	}
	
	// MARK: Helper Method(s)
	
	// Add Student Locations to map view
	private func addAnnotationsFor(students: [Students]) {
		for student in students {
			guard let firstName = student.firstName else {
				continue
			}
			guard let lastName = student.lastName else {
				continue
			}
			guard let mediaURL = student.mediaURL else {
				continue
			}
			guard let latitude = student.location?.latitude else {
				continue
			}
			guard let longitude = student.location?.longitude else {
				continue
			}
			let student = StudentAnnotation(title: "\(firstName) \(lastName)", subtitle: mediaURL, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
			
			annotations.append(student)
		}
		
		mapView.addAnnotations(annotations)
	}
	
	// Problem with map doubling Student Locations when populating. Remove all annotations on map view.
	private func removeAnnotations() {
		mapView.removeAnnotations(annotations)
		annotations = []
	}
	
	// Grab student locations from database and pass students to addAnnotation method
	private func getStudentLocations() {
		removeAnnotations()
		ParseClient.sharedInstance().getStudentLocations { (results, success, error) in
			DispatchQueue.main.async {
				if success {
					let students = ParseClient.sharedInstance().studentArray
					self.addAnnotationsFor(students: students)
				} else {
					Alert.showAlert(title: AlertMessages.error.rawValue, message: AlertMessages.studentLocationsError.rawValue, viewController: self)
				}
			}
		}
	}

	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let identifier = "StudentAnnotation"
		
		if annotation is StudentAnnotation {
			if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
				annotationView.annotation = annotation
				
				return annotationView
			} else {
				let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
				annotationView.isEnabled = true
				annotationView.canShowCallout = true
				
				let btn = UIButton(type: .detailDisclosure)
				annotationView.rightCalloutAccessoryView = btn
				return annotationView
			}
		}
		
		return nil
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		let student = view.annotation as! StudentAnnotation
		let studentURL = student.subtitle
		if Verify.verifyURL(address: studentURL) {
			let webController = storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
			webController.url = studentURL
			present(webController, animated: true, completion: nil)
		} else {
			Alert.showAlert(title: "Error", message: AlertMessages.urlError.rawValue, viewController: self)
		}
		
		
	}
}
