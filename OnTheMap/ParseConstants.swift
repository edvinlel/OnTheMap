//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/26/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation

extension ParseClient {
	
	struct ParseConstants {
		
		// MARK: URLs
		static let ApiScheme = "https"
		static let ApiHost = "parse.udacity.com"
		static let ApiPath = "parse/classes/StudentLocation"
		static let URL = "https://parse.udacity.com/parse/classes/StudentLocation"
	}
	
	struct Methods {
		static let Limit = "?limit=100"
		static let Order = "&order=-updatedAt"
	}
	
	struct JSONResponseKeys {
		static let Results = "results"
	}
}
