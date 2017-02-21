//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/26/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation

class ParseClient {
	// Store students from parsed data to pass around other view controllers
	var studentArray: [Students] = []
	
	func taskForGetMethod(method: String?, completionHandlerForGet: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
		var url = ""
		if let method = method {
			url = ParseConstants.URL + method
		} else {
			url = ParseConstants.URL
		}
		let request = NSMutableURLRequest(url: URL(string: url)!)
		request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { data, response, error in
			if error != nil { // Handle error...
				return
			}
			
			guard let data = data else {
				print("error getting data parse gettask")
				return
			}
			JSONParser.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
		}
		task.resume()
		
		return task
	}
	
	func taskForPostMethod(method: String?, body: [String: AnyObject], completionHandlerForPost: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> URLSessionTask {
		
		var url = ""
		if let method = method {
			url = ParseConstants.URL + method
		} else {
			url = ParseConstants.URL
		}
		
		let request = NSMutableURLRequest(url: URL(string: url)!)
		request.httpMethod = "POST"
		request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
		} catch {
			request.httpBody = nil
			completionHandlerForPost(false, error as NSError?)
		}
		
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { data, response, error in
			if error != nil { // Handle error…
				completionHandlerForPost(false, error as NSError?)
				return
			}
			completionHandlerForPost(true, nil)
		}
		task.resume()
		
		return task
	}
	
	
	// Singleton Instance
	class func sharedInstance() -> ParseClient {
		struct Singleton {
			static var sharedInstance = ParseClient()
		}
		return Singleton.sharedInstance
	}
}
