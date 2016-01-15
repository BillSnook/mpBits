//
//  Networking.swift
//  mpBits
//
//  Created by Bill Snook on 1/14/16.
//  Copyright © 2016 BillSnook. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


typealias TrackBlock = ([String:String]) -> ()
//typealias CoverBlock = ([String:String]) -> ()


class Networking {
	
	class func getTrackData( trackReturn: TrackBlock ) {
		print( "getTrackData" )
		
		Alamofire.request(.GET, "http://streaming.earbits.com/api/v1/track.json", parameters: ["stream_id": "5654d7c3c5aa6e00030021aa" ])
			.responseJSON { response in
				var importantData = [String:String]()
				switch response.result {
				case .Success:
					if let value = response.result.value {
						let json = JSON(value)
						print( "JSON:\n\(json)" )
						importantData[ "name" ] = json["name"].stringValue
						importantData[ "artist_name" ] = json["artist_name"].stringValue
						importantData[ "cover_image" ] = json["cover_image"].stringValue
						importantData[ "media_file" ] = json["media_file"].stringValue
					} else {
						importantData[ "error" ] = "Problem: response value not found"
					}
				case .Failure(let error):
					print( "URLRequest failure: \(error)" )
					importantData[ "error" ] = "Error: \(error)"

				}
				trackReturn( importantData )
		}

	}

	class func getCoverImage ( source: String, imageView: UIImageView ) {
		
		if let urlEncoded = source.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
			Alamofire.request(.GET, NSURL( string: urlEncoded )!, parameters: [:])
				.response { ( _, _, data, _ ) in
					let image = UIImage(data: data! as NSData)
					
					imageView.image = image
			}
		}
		
	}
	
}