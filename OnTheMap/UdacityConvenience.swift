//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/10/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation

extension UdacityClient {
	

	
	func getSessionId(parameters: [String: AnyObject]?, completionHandlerForSession: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
		
		let _ = self.taskForPostMethod(method: Methods.Session, parameters: parameters!) { (results, error) in
			if error != nil {
				completionHandlerForSession(false, error)
			}
			
			guard let account = results?[JSONResponseKeys.Account] as? [String: AnyObject] else {
				return
			}
			guard let key = account[JSONResponseKeys.IDKey] as? String else {
				return
			}
			self.idKey = key
			
			guard let session = results?[JSONResponseKeys.Session] as? [String: AnyObject] else {
				return
			}
			guard let id = session[JSONResponseKeys.SessionID] as? String else {
				return
			}
			self.sessionID = id
			
			completionHandlerForSession(true, nil)
		}
	}
	
	func getUserData() {
		let _ = self.taskForGetMethod(method: Methods.UserID, parameters: nil) { (results, error) in
			guard error == nil else {
				print("error getting user data")
				return
			}
			
			guard let users = results?[JSONResponseKeys.User] as? [String: AnyObject] else {
				print("error getting users dict")
				return
			}
			guard let firstName = users[JSONResponseKeys.FirstName] as? String else {
				print("error getting first_name")
				return
			}
			self.firstName = firstName
			
			guard let lastName = users[JSONResponseKeys.LastName] as? String else {
				print("error getting last name")
				return
			}
			self.lastName = lastName
			
			guard let websiteURL = users[JSONResponseKeys.URL] as? String else {
				print("error getting website url")
				self.mediaURL = ""
				return
			}
			
			self.mediaURL = websiteURL
			
		}
	}
	
	func logOut(completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
		let _ = self.taskForDeleteMethod(method: Methods.Session) { (results, error) in
			guard error == nil else {
				completionHandler(false, error)
				return
			}
			self.sessionID = nil
			completionHandler(true, nil)
		}
	}
}

















