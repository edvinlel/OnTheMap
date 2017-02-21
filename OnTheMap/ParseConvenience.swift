//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/26/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation

extension ParseClient {
	
	// Make a request to get student locations and store it to the Student array
	func getStudentLocations(completionHandlerForStudents: @escaping (_ results: AnyObject?, _ success: Bool, _ error: NSError?) -> Void) {
		let _ = taskForGetMethod(method: ParseClient.Methods.Limit + ParseClient.Methods.Order) { (results, error) in
			guard error == nil else {
				print("error in getStudentLocations")
				completionHandlerForStudents(nil, false, error)
				return
			}
			
			completionHandlerForStudents(results, true, nil)
			
			guard let results = results?[JSONResponseKeys.Results] as? [[String: AnyObject]] else {
				return
			}
			self.studentArray = Students.studentsFromResults(results: results)
		
			
			
		}
	}
}
