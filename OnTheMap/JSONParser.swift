//
//  JSONParser.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 2/12/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation

class JSONParser: NSObject {
	// Parse JSON data received from network completion handlers and pass it back.
	class func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
		
		var parsedResult: AnyObject! = nil
		do {
			parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
		} catch {
			let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
			completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
		}
		
		completionHandlerForConvertData(parsedResult, nil)
	}
}
