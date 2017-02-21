//
//  StudentAnnotation.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 2/1/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation
import MapKit

class StudentAnnotation: NSObject, MKAnnotation {
	var title: String?
	var subtitle: String?
	var coordinate: CLLocationCoordinate2D
	
	init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.subtitle = subtitle
		self.coordinate = coordinate
	}
}
