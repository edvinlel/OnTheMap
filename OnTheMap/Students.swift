//
//  Students.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/26/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

struct Students {
	let firstName: String?
	let lastName: String?
	let location: CLLocationCoordinate2D?
	let mediaURL: String?
	
	init(dictionary: [String: AnyObject]) {
		if let firstName = dictionary["firstName"] as? String,
			let lastName = dictionary["lastName"] as? String {
				self.firstName = firstName
				self.lastName = lastName
		} else {
			self.firstName = ""
			self.lastName = ""
		}
		
		if let latitude = dictionary["latitude"] as? Double,
			let longitude = dictionary["longitude"] as? Double {
				self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		} else {
			self.location = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
		}
		
		if let mediaURL = dictionary["mediaURL"] as? String {
			self.mediaURL = mediaURL
		} else {
			self.mediaURL = ""
		}
		
	}
	
	// Grab data passed by JSON and store to an instance of Student; Passed through initializer to parse.
	static func studentsFromResults(results: [[String: AnyObject]]) -> [Students] {
		var students = [Students]()
		for student in results {
			students.append(Students(dictionary: student))
		}
		
		return students
	}

}
