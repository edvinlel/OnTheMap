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
		
//		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//		

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
				if error != nil {
					print("hellooooooo: fail")
				} else {
					print("hellooooooo: success")
				}
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
					print("FALSEEEEEEEEEEEEE")
					let errorMessage = "/(error?.localizedDescription)"
					print(errorMessage)
					let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
					let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
					alert.addAction(action)
					DispatchQueue.main.async {
						self.present(alert, animated: true, completion: nil)
					}
				}
			}
		} else {
			Alert.showAlert(title: AlertMessages.error.rawValue, message: AlertMessages.emptyTextFieldError.rawValue, viewController: self)
		}
	}
	
//	@objc func keyboardWillShow(notification: NSNotification) {
//		
//		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//			self.view.frame.origin.y -= keyboardSize.height
//		}
//		
//	}
//	
//	func keyboardWillHide(notification: NSNotification) {
//		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//			self.view.frame.origin.y += keyboardSize.height
//		}
//	}
	
//	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//		if textField == usernameTextField {
//			passwordTextField.becomeFirstResponder()
//			view.frame.origin.y -= 100
//		} else {
//			passwordTextField.resignFirstResponder()
//			view.frame.origin.y += 100
//		}
//		
//		return true
//	}
	
}

