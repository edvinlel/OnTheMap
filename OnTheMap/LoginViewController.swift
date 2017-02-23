//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/4/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		usernameTextField.delegate = self
		passwordTextField.delegate = self	

		let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	@objc private func hideKeyboard() {
		view.endEditing(true)
	}

	@IBAction func onLoginButtonPressed(_ sender: UIButton) {
		// Make sure text fields are not empty before moving forward; if empty, prompt error alert
		if usernameTextField.text != "" && passwordTextField.text != "" {
			let param = ["udacity" : ["username" : "\(usernameTextField.text!)", "password" : "\(passwordTextField.text!)"]]
			
			UdacityClient.sharedInstance().getSessionId(parameters: param as [String: AnyObject]) { (success, error) in
				
				if success {
					// Store the logged in users information
					UdacityClient.sharedInstance().getUserData()
					DispatchQueue.main.async {
						// present the next view controller
						let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
						self.present(tabBarController, animated: true, completion: nil)
					}
				} else {
					// send an error message to the user about a problem with getting users data from the database
					DispatchQueue.main.async {
						Alert.showAlert(title: AlertMessages.error.rawValue, message: AlertMessages.loginError.rawValue, viewController: self)
					}
				}
			}
		} else {
			Alert.showAlert(title: AlertMessages.error.rawValue, message: AlertMessages.emptyTextFieldError.rawValue, viewController: self)
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == usernameTextField {
			passwordTextField.becomeFirstResponder()
		} else {
			view.endEditing(true)
		}
		
		return true
	}
	
}

