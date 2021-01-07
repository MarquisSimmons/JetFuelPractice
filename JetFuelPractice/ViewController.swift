//
//  ViewController.swift
//  JetFuelPractice
//
//  Created by Marquis Simmons on 1/4/21.
//

import UIKit

class ViewController: UIViewController {
    var campaignItems = [CampaignItem]()
    
    let collectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(CampaignCollectionViewCell.self, forCellWithReuseIdentifier: CampaignCollectionViewCell.reuseIdentifier)
        return collection
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        populateFeed()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray6
        collectionView.showsVerticalScrollIndicator = false
    }
    
    fileprivate func populateFeed() {
        // Populate Feed
        NetworkUtils.getFeed {[weak self] (returnedItems, error) in
            guard let strongSelf = self else {
                return
            }
            if let returnedError = error {
                print(returnedError)
            } else {
                strongSelf.campaignItems = returnedItems!
                DispatchQueue.main.async {
                    strongSelf.collectionView.reloadData()
                    print(strongSelf.campaignItems.count)
                }
                
            }
        }
    }
    
    
}
// MARK: - CollectionView Delegate methods

extension ViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        campaignItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CampaignCollectionViewCell.reuseIdentifier, for: indexPath) as! CampaignCollectionViewCell
        if (indexPath.item < campaignItems.count){
            let campaignItem = campaignItems[indexPath.item]
            cell.configure(with: campaignItem)
        }

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2.0)
    }
    
}
extension ViewController: MediaButtonResponder {
    func downloadLink(sender: Any?) {
        guard let feedCell = sender as? FeedCollectionViewCell else { return }
        if let feedItem = feedCell.feedItem {
            if let downloadUrl = URL(string: feedItem.downloadLink) {
                NetworkUtils.downloadContent(contentUrl: downloadUrl, contentType: feedItem.mediaType)

            } else {
                print("Invalid link:", feedItem.downloadLink)
            }
        }

        
    }

    func copyLink(sender: Any?) {
        if let feedCell = sender as? FeedCollectionViewCell {
            UIPasteboard.general.string = feedCell.feedItem?.trackingLink
            let linkCopiedAlert = UIAlertController(title: "Copied!", message: "Media link was copied successfully.", preferredStyle: .alert)
            linkCopiedAlert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(linkCopiedAlert, animated: true, completion: nil)
        }
    }


}
