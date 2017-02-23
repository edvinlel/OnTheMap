//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/10/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation

class UdacityClient {
	
	var sessionID: String? = nil
	var idKey: String? = nil
	var firstName: String? = nil
	var lastName: String? = nil
	var latitude: Double? = nil
	var longitude: Double? = nil
	var mediaURL: String? = nil
	
	// MARK: Get request
	func taskForGetMethod(method: String, parameters: [String: AnyObject]?, completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
		
		let url = UdacityConstants.URL + method
		let request = NSMutableURLRequest(url: URL(string: url)!)
		let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
			guard error == nil else {
				print("There was an error with your request")
				completionHandlerForGet(nil, error! as NSError?)
				return
			}
			
			guard let data = data else {
				print("Error getting data from taskForGetMethod")
				return
			}
			let newData = data.subdata(in: Range(5...Int(data.count)))
			JSONParser.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGet)
		}
		task.resume()
		
		return task
	}


	
	func taskForPostMethod(method: String, parameters: [String: AnyObject]?, completionHandlerForPost: @escaping ( _ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
		let url = UdacityConstants.URL + method
		let request = NSMutableURLRequest(url: URL(string: url)!)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")

		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
		} catch let err as NSError {
			
			completionHandlerForPost(nil, err)
			
		}
		
		let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
			guard error == nil else {
				print("error in taskForPostMethod")
				completionHandlerForPost(nil, error as NSError?)
				return
			}
			
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				let statusCode = (response as? HTTPURLResponse)?.statusCode
				
				let err = NSError.init(domain:"\(statusCode)", code: statusCode!, userInfo: nil)
				completionHandlerForPost(nil, err)
				print("Your request returned a status code other than 2xx!")
				return
			}
			
			guard let data = data else {
				print("no data was returned")
				return
			}
			let newData = data.subdata(in: Range(5...Int(data.count)))
			JSONParser.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPost)
		}
		task.resume()
		
		return task
	}
	
	func taskForDeleteMethod(method: String, completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
		let url = UdacityConstants.URL + method
		let request = NSMutableURLRequest(url: URL(string: url)!)
		request.httpMethod = "DELETE"
		var xsrfCookie: HTTPCookie? = nil
		let sharedCookieStorage = HTTPCookieStorage.shared
		for cookie in sharedCookieStorage.cookies! {
			if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
		}
		if let xsrfCookie = xsrfCookie {
			request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
		}
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { data, response, error in
			if error != nil { // Handle error…
				return
			}
			guard let data = data else {
				print("no data was returned - delete")
				return
			}
			
			let newData = data.subdata(in: Range(5...Int(data.count)))
			JSONParser.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDelete)
		}
		task.resume()

		return task
	}

	
	// MARK: Shared Instance
	
	class func sharedInstance() -> UdacityClient {
		struct Singleton {
			static var sharedInstance = UdacityClient()
		}
		return Singleton.sharedInstance
	}
}
