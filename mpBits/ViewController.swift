//
//  ViewController.swift
//  mpBits
//
//  Created by Bill Snook on 1/14/16.
//  Copyright © 2016 BillSnook. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		Networking.getTrackData( returnDict )
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	func returnDict( resultDict: [String:String] ) -> () {
//		print( "Got result: \(resultDict)" )
		
		if let fileName = resultDict["media_file"] {
			if Networking.getMediaFile( fileName ) {
				print( "Got file" )
			} else {
				print( "No file retrieved" )
			}
		} else {
			print( "No media file URL found" )
		}
	}
}

