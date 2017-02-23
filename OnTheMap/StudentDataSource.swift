//
//  StudentDataSource.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 2/22/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation

class StudentDataSource {
	// Store students from parsed data to pass around other view controllers
	var studentData = [Students]()
	
	// Singleton
	static let sharedInstance = StudentDataSource()
	
	private init() {} //This prevents others from using the default '()' initializer for this class.
}
