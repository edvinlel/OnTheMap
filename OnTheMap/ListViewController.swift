//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 1/31/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		getStudentLocations()
	}
	
	// MARK: IBAction(s)
	
	@IBAction func onPinButtonPressed(_ sender: UIButton) {
		let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoVC") as! PostInfoViewController
		present(infoVC, animated: true, completion: nil)
	}
	
	@IBAction func onRefreshButtonPressed(_ sender: UIButton) {
		getStudentLocations()
	}

	@IBAction func onLogoutButtonPressed(_ sender: UIButton) {
		UdacityClient.sharedInstance().logOut { (success, error) in
			if success {
				DispatchQueue.main.async {
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
	
	// MARK: UITableViewDelegate/DataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return StudentDataSource.sharedInstance.studentData.count
	}
 
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StudentCell
		
		let student = StudentDataSource.sharedInstance.studentData[indexPath.row]
		
		if student.firstName == "" || student.lastName == "" {
			cell.fullNameLabel?.text = "Oops! No Name"
		} else if student.mediaURL == "" {
			cell.urlLabel?.text = "somethingwentwrong!.com"
		} else {
			if let firstName = student.firstName,
				let lastName = student.lastName {
				cell.fullNameLabel?.text = "\(firstName) \(lastName)"
			}
		}
		
		cell.urlLabel?.text = student.mediaURL
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let student = StudentDataSource.sharedInstance.studentData[indexPath.row]
		
		guard let mediaURL = student.mediaURL else {
			return
		}
		
		let webController = storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
		
		if Verify.verifyURL(address: mediaURL) {
			webController.url = mediaURL
			
			present(webController, animated: true, completion: nil)
		} else {
			Alert.showAlert(title: "Error", message: AlertMessages.urlError.rawValue, viewController: self)
		}
	}
	
	// MARK: Helper Method(s)
	
	// Grab student locations from database and reload table view data
	private func getStudentLocations() {
		ParseClient.sharedInstance().getStudentLocations { (results, success, error) in
			DispatchQueue.main.async {
				if success {
					self.tableView.reloadData()
					
				} else {
					Alert.showAlert(title: "Error", message: (error?.localizedDescription)!, viewController: self)
				}
			}
		}
	}

}
