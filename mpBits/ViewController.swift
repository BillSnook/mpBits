//
//  ViewController.swift
//  mpBits
//
//  Created by Bill Snook on 1/14/16.
//  Copyright © 2016 BillSnook. All rights reserved.
//

import UIKit
import Jukebox


class ViewController: UIViewController, JukeboxDelegate {

	@IBOutlet var artistName: UILabel!
	@IBOutlet var trackName: UILabel!
	@IBOutlet var albumImage: UIImageView!
	@IBOutlet var backButton: UIButton!
	@IBOutlet var forwardButton: UIButton!
	@IBOutlet var playButton: UIButton!
	
	private var jukeBox: Jukebox?
	private var tuneArray: Array<Dictionary<String,String>> = []	// Preserve entries for skip to previous track
	private var	tuneIndex = 0										// Index of current track

	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		Networking.getTrackData( returnDict )
		
		playButton.setTitle("Loading", forState: .Normal)
		backButton.setTitle("<<", forState: .Normal)
		forwardButton.setTitle(">>", forState: .Normal)
		backButton.enabled = false
}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	func returnDict( resultDict: [String:String] ) -> () {
		print( "Got result: \(resultDict)" )
		
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
			jukeBox = Jukebox(delegate: self, items: [
				JukeboxItem(URL: NSURL(string: mediaFileName)!)
				])
			jukeBox?.play()
		} else {
			print( "No media file URL found" )
		}
	}

// protocol delegates
	
	func jukeboxStateDidChange(jukebox : Jukebox) {
		
		print( "jukeboxStateDidChange: \(jukebox.state)" )
		switch jukebox.state {
		case .Ready:
			playButton.setTitle("Play", forState: .Normal)
			playButton.enabled = true
		case .Playing:
			playButton.setTitle("Pause", forState: .Normal)
			playButton.enabled = true
		case .Failed:
			playButton.setTitle("Failed", forState: .Normal)
			playButton.enabled = false
		case .Paused:
			playButton.setTitle("Play", forState: .Normal)
			playButton.enabled = true
		case .Loading:
			playButton.setTitle("Loading", forState: .Normal)
			playButton.enabled = false
		}
	}
	
	func jukeboxPlaybackProgressDidChange(jukebox : Jukebox) {
		
//		print( "jukeboxPlaybackProgressDidChange: \(jukebox.currentItem?.currentTime)" )
	}
	
	func jukeboxDidLoadItem(jukebox : Jukebox, item : JukeboxItem) {
		
		print( "jukeboxDidLoadItem - duration: \(item.duration)" )
//		jukebox.play()

	}

	@IBAction func playTouched(sender: UIButton) {
		print( "playTouched: \(self.jukeBox!.state)" )
		switch self.jukeBox!.state {
		case .Ready, .Paused:
			self.jukeBox!.play()
		case .Playing:
			self.jukeBox!.pause()
		default:
			break
		}
	}
	
	@IBAction func backTouched(sender: UIButton) {
		self.jukeBox!.stop()
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
		self.jukeBox!.stop()
		backButton.enabled = true
		if tuneIndex++ < (tuneArray.count - 1) {
			setupTrack( tuneArray[tuneIndex])
		} else {
			Networking.getTrackData( returnDict )
		}
	}
}

