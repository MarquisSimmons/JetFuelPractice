//
//  NetworkUtils.swift
//  JetFuelPractice
//
//  Created by Marquis Simmons on 1/4/21.
//

import UIKit
import Photos
public class NetworkUtils {
    static let DEFAULT_LINK = URL(string: "https://www.plugco.in/public/take_home_sample_feed")!
    static let DOCUMENTS_PATH = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
    
    
    /// This function is responsible for retrieving an Image from a url and converting it into a UIImage
    /// - Parameters:
    ///   - imageUrl: The URL of the Image we want to display
    ///   - completion: The completion handler
    ///   - image: The UIImage retrieved or nil if there was an error
    ///   - error: The error returned or nil if we retrieved the image successfully
    
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
    
    
    
    /// This function is responsible for retrieving an Image from a url and converting it into a UIImage
    /// - Parameters:
    ///   - completion: The completion handler
    ///   - campaignItems: The Object representation of the items in the feed
    ///   - error: The error returned or nil if we retrieved the feed json successfully
    
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
                            let campaignItem = CampaignItem(with:campaign)
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
    
    
    /// This function is responsible for downloading media from the feed into the user's Photo Library
    /// - Parameters:
    ///   - contentUrl: The url of the media we want to download
    ///   - contentType: The content type of the media we want to download. It can be  a video or a photo
    static func downloadContent(contentUrl: URL, contentType: String){
        let fileExtension = contentType == "video" ? ".mov" : ".jpg"
        let filePath = DOCUMENTS_PATH.appendingPathComponent(String(format: "JetFuelMedia%d" + fileExtension, arc4random() % 1000))
        URLSession.shared.downloadTask(with: contentUrl) { (tempUrl, response, error) in
            if let returnedError = error {
                print("There was an error downloading the Media:", returnedError.localizedDescription)
            }
            else if let localUrl = tempUrl{
                do {
                    try FileManager.default.moveItem(at: localUrl, to: filePath)
                    PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                        
                        // check if user authorized access photos for your app
                        if authorizationStatus == .authorized {
                            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: filePath)}) { completed, error in
                                if completed {
                                    print("Video asset created")
                                } else {
                                    print(error?.localizedDescription)
                                }
                            }
                        }
                    })
                } catch let saveError {
                    print("There was an error saving the Media:", saveError.localizedDescription)
                    
                }
            }
        }.resume()
        
    }
    
    
    
    
    
    
}
