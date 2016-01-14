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


class Networking {
	
	class func getTrackData( trackReturn: TrackBlock ) {
		
		Alamofire.request(.GET, "http://streaming.earbits.com/api/v1/track.json", parameters: ["stream_id": "5654d7c3c5aa6e00030021aa" ])
			.responseJSON { response in
				var importantData = [String:String]()
				switch response.result {
				case .Success:
					if let value = response.result.value {
						let json = JSON(value)
//						print( json )
						importantData[ "name" ] = json["name"].stringValue
						importantData[ "artist_name" ] = json["artist_name"].stringValue
						importantData[ "cover_image" ] = json["cover_image"].stringValue
						importantData[ "media_file" ] = json["media_file"].stringValue
					} else {
						importantData[ "error" ] = "Problem: response value not found"
					}
				case .Failure(let error):
					print(error)
					importantData[ "error" ] = "Error: \(error)"

				}
				trackReturn( importantData )
		}

	}

	class func getMediaFile( fileName: String )->Bool {
		
		print( "Get file: \(fileName)" )
//		Alamofire.request(.GET, fileName).response() {
//			(_, _, data, _) in
//			
//			
//		}
		return false
	}
}