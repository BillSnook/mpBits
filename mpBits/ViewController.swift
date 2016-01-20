//
//  ViewController.swift
//  mpBits
//
//  Created by Bill Snook on 1/14/16.
//  Copyright © 2016 BillSnook. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

	@IBOutlet var artistName: UILabel!
	@IBOutlet var trackName: UILabel!
	@IBOutlet var albumImage: UIImageView!
	@IBOutlet var backButton: UIButton!
	@IBOutlet var forwardButton: UIButton!
	@IBOutlet var playButton: UIButton!
	
	private var tuneArray: Array<Dictionary<String,String>> = []	// Preserve entries for skip to previous track
	private var	tuneIndex = 0										// Index of current track

	private var audioPlayer: AVPlayer?
	private var audioPlaying = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		Networking.getTrackData( returnDict )
		
		playButton.setTitle("Pause", forState: .Normal)
		playButton.enabled = true
		backButton.setTitle("<<", forState: .Normal)
		backButton.enabled = false
		forwardButton.setTitle(">>", forState: .Normal)
}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	func returnDict( resultDict: [String:String] ) -> () {
//		print( "Got result: \(resultDict)" )
		
		tuneArray.append(resultDict)
		tuneIndex = tuneArray.count - 1		// Current index
		if tuneIndex > 0 {
			backButton.enabled = true
		}
		
		setupTrack( resultDict )
		
	}
	
	func setupTrack( resultDict: [String:String] ) {
		if let performer = resultDict["artist_name"]! as String? {
			artistName.text = performer
		} else {
			artistName.text = "Unknown"
		}
		if let track = resultDict["name"]! as String? {
			trackName.text = track
		} else {
			trackName.text = "Unknown"
		}
		if let coverImage = resultDict["cover_image"]! as String? {
			Networking.getCoverImage( coverImage, imageView: self.albumImage )
		} else {
			print( "No album cover image found" )
		}
		if let mediaFileName = resultDict["media_file"] {

			// Play here
			if let url = NSURL( string: mediaFileName ) {
				audioPlayer = AVPlayer( playerItem: AVPlayerItem( asset: AVURLAsset( URL: url ) ) )
				audioPlayer?.play()
				playButton.setTitle("Pause", forState: .Normal)
				playButton.enabled = true
				
			}
			
		} else {
			print( "No media file URL found" )
		}
	}

// protocol delegates
	

	@IBAction func playTouched(sender: UIButton) {
//		print( "playTouched" )

		if audioPlaying {
			audioPlaying = false
			audioPlayer?.pause()
			playButton.setTitle("Play", forState: .Normal)
		} else {
			audioPlaying = true
			audioPlayer?.play()
			playButton.setTitle("Pause", forState: .Normal)
		}
	}
	
	@IBAction func backTouched(sender: UIButton) {
		audioPlayer?.pause()
		tuneIndex--
		if tuneIndex <= 0 {
			backButton.enabled = false
			tuneIndex = 0
		} else {
			backButton.enabled = true
		}
		setupTrack( tuneArray[tuneIndex])
	}
	
	
	@IBAction func nextTouched(sender: UIButton) {
		audioPlayer?.pause()
		backButton.enabled = true
		if tuneIndex++ < (tuneArray.count - 1) {
			setupTrack( tuneArray[tuneIndex])
		} else {
			Networking.getTrackData( returnDict )
		}
	}
}

