//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/10/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation

extension UdacityClient {
	
	// MARK: Constants
	
	
	struct UdacityConstants {
		// MARK: URLs
		static let APIScheme = "https"
		static let APIHost = "www.udacity.com"
		static let APIPath = "api/session"
		static let URL = "https://www.udacity.com/api/"
	}
	
	// MARK: Methods
	struct Methods {
		
		// MARK: Account
		static let Session = "session"
		static let UserID = "users/\(UdacityClient.sharedInstance().idKey!)"
		
	}
	
	
	
	// MARK: Parameter Keys
	struct ParameterKeys {
		static let Udacity = "udacity"
		static let Username = "username"
		static let Password = "password"
	}
	
	// MARK: JSON Body Keys
	struct JSONResponseKeys {
		static let Session = "session"
		static let SessionID = "id"
		static let Account = "account"
		static let User = "user"
		static let FirstName = "first_name"
		static let LastName = "last_name"
		static let IDKey = "key"
		static let URL = "website_url"
	}
}
