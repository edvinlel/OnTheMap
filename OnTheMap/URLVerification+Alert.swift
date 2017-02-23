//
//  URLVerification+Alert.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 2/16/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import Foundation
import UIKit

struct Verify {
	
	// Verify the url before sending to web view
	static func verifyURL(address: String?) -> Bool {
		// Check address for nil
		if let address = address {
			if let url = URL(string: address) {
				// Check if address can be opened
				return UIApplication.shared.canOpenURL(url)
			}
		}
		return false
	}
}

enum AlertMessages: String {
	case error = "Error"
	case emptyTextFieldError = "Text fields cannot be empty"
	case studentLocationsError = "Error getting student locations."
	case postingError = "Error posting your information to the servers."
	case urlError = "Error verifying your url."
	case locationError = "Error finding location."
	case postInfoError = "Error posting location to server."
	case loginError = "Invalid Credentials/Error connecting with the server. Please try again."
	case offlineError = "The Internet connection appears to be offline."
}

struct Alert {
	static func showAlert(title: String, message: String, viewController: UIViewController) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(action)
		viewController.present(alert, animated: true, completion: nil)
	}
}
