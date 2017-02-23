//
//  WebViewController.swift
//  OnTheMap
//
//  Created by Edvin Lellhame on 2/1/17.
//  Copyright © 2017 Edvin Lellhame. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
	
	@IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var activityView: UIView!
	@IBOutlet weak var urlAddress: UILabel!
	
	var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
		
		guard let url = url else {
			print("error getting url")
			return
		}
		urlAddress.text = url
		
		let request = URLRequest(url: URL(string: url)!)
		webView.loadRequest(request)
		
		
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		activityView.layer.cornerRadius = 8.0
		activityIndicator.startAnimating()
	}

	@IBAction func onCloseButtonPressed(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		activityIndicator.stopAnimating()
		activityView.isHidden = true
		activityIndicator.hidesWhenStopped = true
	}

}
