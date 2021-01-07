//
//  FeedCollectionViewCell.swift
//  JetFuelPractice
//
//  Created by Marquis Simmons on 1/4/21.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FeedCell"
    var feedItem: FeedItem? = nil
    
    let mediaPreviewImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
        
    }()
    let mediaControlButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    let linkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "link"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.tintColor = .systemGray3
        button.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 0.5
        return button
        
    }()
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.tintColor = .systemGray3
        button.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 0.5        
        
        return button
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        mediaPreviewImageView.addSubview(overlayView)
        mediaPreviewImageView.addSubview(mediaControlButton)
        
        // Media Control buttons set up - Constraints
        let controlButtonConstraints = [
            mediaControlButton.centerXAnchor.constraint(equalTo: mediaPreviewImageView.centerXAnchor),
            mediaControlButton.centerYAnchor.constraint(equalTo: mediaPreviewImageView.centerYAnchor),
            mediaControlButton.widthAnchor.constraint(equalTo: mediaPreviewImageView.widthAnchor, multiplier: 0.25),
            mediaControlButton.heightAnchor.constraint(equalTo: mediaControlButton.widthAnchor, multiplier: 1.3)
        ]
        
        // Download and copy link button setup - Stack creation
        let horizontalButtonStack = UIStackView(arrangedSubviews: [linkButton,downloadButton])
        horizontalButtonStack.axis = .horizontal
        horizontalButtonStack.distribution = .fill
        horizontalButtonStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalButtonStack.layer.cornerRadius = 10
        horizontalButtonStack.layer.borderColor = UIColor.systemGray5.cgColor
        horizontalButtonStack.layer.borderWidth = 1
        
        // Creating Cell view stack (ImageView + Download and copy link buttons)
        let feedCellStackView = UIStackView(arrangedSubviews: [mediaPreviewImageView,horizontalButtonStack])
        feedCellStackView.spacing = 5
        feedCellStackView.axis = .vertical
        feedCellStackView.distribution = .fill
        feedCellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Download and copy link button setup - Stack constraints
        let horizontalButtonStackConstraints = [
            horizontalButtonStack.leadingAnchor.constraint(equalTo: horizontalButtonStack.superview!.leadingAnchor),
            horizontalButtonStack.trailingAnchor.constraint(equalTo: horizontalButtonStack.superview!.trailingAnchor),
        ]
        
        // Thumbnail Image view constrains
        let mediaPreviewImageViewConstraints = [
            mediaPreviewImageView.leadingAnchor.constraint(equalTo: feedCellStackView.leadingAnchor),
            mediaPreviewImageView.trailingAnchor.constraint(equalTo: feedCellStackView.trailingAnchor),
            mediaPreviewImageView.topAnchor.constraint(equalTo: feedCellStackView.topAnchor),
        ]
        let overlayViewConstraints = [
            overlayView.leadingAnchor.constraint(equalTo: mediaPreviewImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: mediaPreviewImageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: mediaPreviewImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: mediaPreviewImageView.bottomAnchor)
        ]
        
        let feedCellStackViewConstraints = [
            feedCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feedCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            feedCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        
        let buttonStackButtonConstraints = [
            linkButton.leadingAnchor.constraint(equalTo: horizontalButtonStack.leadingAnchor),
            linkButton.topAnchor.constraint(equalTo: horizontalButtonStack.topAnchor),
            linkButton.bottomAnchor.constraint(equalTo: horizontalButtonStack.bottomAnchor),
            linkButton.widthAnchor.constraint(equalTo: mediaPreviewImageView.widthAnchor, multiplier: 0.5),
            linkButton.heightAnchor.constraint(equalTo: linkButton.widthAnchor, multiplier: 0.95),
        ]
        
        contentView.addSubview(feedCellStackView)
        NSLayoutConstraint.activate(controlButtonConstraints)
        NSLayoutConstraint.activate(horizontalButtonStackConstraints)
        NSLayoutConstraint.activate(mediaPreviewImageViewConstraints)
        NSLayoutConstraint.activate(feedCellStackViewConstraints)
        NSLayoutConstraint.activate(buttonStackButtonConstraints)
        NSLayoutConstraint.activate(overlayViewConstraints)
        
        
        
    }
    func configure(with feedItem: FeedItem){
        linkButton.addTarget(self, action: #selector(copyLinkButtonPressed), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)


        self.feedItem = feedItem
        if feedItem.mediaType == "video" {
            mediaControlButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else {
            mediaControlButton.isEnabled = false
        }
        guard let feedImageUrl = URL(string: feedItem.imageLink) else { return }
        NetworkUtils.getImageFromURL(imageUrl: feedImageUrl) { [weak self] (image, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("There was an error: ", error)
            }
            else {
                strongSelf.mediaPreviewImageView.image = image
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   @objc func copyLinkButtonPressed() {
    UIApplication.shared.sendAction(#selector(MediaButtonResponder.copyLink), to: nil, from: self, for: nil)
        
    }
    @objc func downloadButtonPressed() {
     UIApplication.shared.sendAction(#selector(MediaButtonResponder.downloadLink), to: nil, from: self, for: nil)
         
     }
    
    
    
}
@objc protocol MediaButtonResponder: AnyObject {
    func copyLink(sender: Any?)
    func downloadLink(sender: Any?)
}
