//
//  NetworkUtils.swift
//  JetFuelPractice
//
//  Created by Marquis Simmons on 1/4/21.
//

import UIKit
public enum NetworkUtils {
    static let DEFAULT_LINK = URL(string: "https://www.plugco.in/public/take_home_sample_feed")!
    
    static func getImageFromURL(imageUrl: URL, completion: @escaping (_ image: UIImage?, _ error: String?) -> Void) {
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error {
                completion(nil,error.localizedDescription)
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!){
                    completion(image, nil)
                }
            }
        }.resume()
        
    }
    
    static func getFeed(completion: @escaping (_ campaignItems: [CampaignItem]?, _ error: String?) -> Void) {
        URLSession.shared.dataTask(with: DEFAULT_LINK) { (data, response, error) in
            if let error = error {
                print("There was an error:", error.localizedDescription)
                completion(nil, error.localizedDescription)
                return
            }
            else {
                do {
                    var campaignItems = [CampaignItem]()
                    let feedJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    for campaignList in feedJson as! [String: Any] {
                        for campaign in campaignList.value as! [[String:Any]] {
                            var mediaList = [FeedItem]()
                            let campaignName = campaign["campaign_name"] as! String
                            let campaignId = campaign["id"] as! Int
                            let campaignIcon = campaign["campaign_icon_url"] as! String
                            let campaignPayPerInstall = campaign["pay_per_install"] as! String
                            let campaignMedia = campaign["medias"] as! [[String:Any]]
                            
                            for media in campaignMedia {
                                let imageLink = media["cover_photo_url"] as! String
                                let downloadLink = media["download_url"] as! String
                                let trackingLink = media["tracking_link"] as! String
                                let mediaType = media["media_type"] as! String
                                let mediaItem =  FeedItem(imageLink: imageLink, mediaType: mediaType, downloadLink: downloadLink, trackingLink: trackingLink)
                                mediaList.append(mediaItem)
                            }
                            let campaignItem = CampaignItem(campaignImageLink: campaignIcon, campaignName: campaignName, campaignPayPerInstall: campaignPayPerInstall, campaignMedia: mediaList, campaignId: campaignId)
                            campaignItems.append(campaignItem)
                        }
                    }
                    completion(campaignItems,nil)
                    return
                } catch let jsonError {
                    completion(nil,jsonError.localizedDescription)
                }
                
            }
            
        }.resume()
    }
    
    
    
}
