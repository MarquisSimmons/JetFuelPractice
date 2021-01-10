//
//  CampaignItem.swift
//  JetFuelPractice
//
//  Created by Marquis Simmons on 1/5/21.
//

import Foundation
public struct CampaignItem {
    let campaignImageLink: String
    let campaignName: String
    let campaignPayPerInstall: String
    var campaignMedia = [FeedItem]()
    let campaignId: Int
    
    init(with json: [String:Any] ){
        campaignName = json["campaign_name"] as! String
        campaignId = json["id"] as! Int
        campaignImageLink = json["campaign_icon_url"] as! String
        campaignPayPerInstall = json["pay_per_install"] as! String
        
        let campaignMediaJson = json["medias"] as! [[String:Any]]
        for media in campaignMediaJson {
            let mediaItem = FeedItem(with: media)
            campaignMedia.append(mediaItem)
        }
    }
    
}
