//
//  FeedItem.swift
//  JetFuelPractice
//
//  Created by Marquis Simmons on 1/4/21.
//

import Foundation
public struct FeedItem  {
    let imageLink: String
    let mediaType: String
    let downloadLink: String
    let trackingLink: String
    
    init(with json: [String:Any]) {
      imageLink = json["cover_photo_url"] as! String
      downloadLink = json["download_url"] as! String
      trackingLink = json["tracking_link"] as! String
      mediaType = json["media_type"] as! String
    }
}
