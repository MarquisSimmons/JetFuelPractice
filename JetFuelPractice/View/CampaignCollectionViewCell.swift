//
//  CampaignCollectionViewCell.swift
//  JetFuelPractice
//
//  Created by Marquis Simmons on 1/4/21.
//

import UIKit

class CampaignCollectionViewCell: UICollectionViewCell{
    
    static let reuseIdentifier = "CampaignCell"
    var campaignItem : CampaignItem? = nil
    
    let campaignIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let campaignNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let payPerInstallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let feedCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        return collectionView
    }()
    
    let campaignHeaderView : UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .systemBackground

        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        feedCollection.dataSource = self
        feedCollection.delegate = self
        
        let campaignInfoStackView = UIStackView(arrangedSubviews: [campaignNameLabel,payPerInstallLabel])
        campaignInfoStackView.axis = .vertical
        campaignInfoStackView.distribution = .fillEqually
        campaignInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let wholeCellStack = UIStackView(arrangedSubviews: [campaignHeaderView,feedCollection])
        wholeCellStack.axis = .vertical
        wholeCellStack.spacing = 0
        wholeCellStack.distribution = .fill
        wholeCellStack.translatesAutoresizingMaskIntoConstraints = false
        wholeCellStack.backgroundColor = .clear
        
        // Campaign Header Set Up - Adding constraints
        let iconConstraints = [
            campaignIcon.leadingAnchor.constraint(equalTo: campaignHeaderView.leadingAnchor, constant: 10),
            campaignIcon.centerYAnchor.constraint(equalTo: campaignHeaderView.centerYAnchor),
            campaignIcon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.18),
            campaignIcon.heightAnchor.constraint(equalTo: campaignIcon.widthAnchor),
        ]
        let labelConstraints = [
            campaignNameLabel.leadingAnchor.constraint(equalTo: campaignInfoStackView.leadingAnchor),
            campaignNameLabel.trailingAnchor.constraint(equalTo: campaignInfoStackView.trailingAnchor),
            campaignNameLabel.heightAnchor.constraint(equalToConstant: 30),
            payPerInstallLabel.leadingAnchor.constraint(equalTo: campaignNameLabel.leadingAnchor),
            payPerInstallLabel.trailingAnchor.constraint(equalTo: campaignNameLabel.trailingAnchor),
            payPerInstallLabel.heightAnchor.constraint(equalTo: campaignNameLabel.heightAnchor),

        ]
        let infoStackViewConstraints = [
            campaignInfoStackView.leadingAnchor.constraint(equalTo: campaignIcon.trailingAnchor, constant: 5),
            campaignInfoStackView.centerYAnchor.constraint(equalTo: campaignHeaderView.centerYAnchor),
            campaignInfoStackView.trailingAnchor.constraint(equalTo: campaignHeaderView.trailingAnchor, constant: -50)
        ]
        let headerViewConstraints = [
            campaignHeaderView.leadingAnchor.constraint(equalTo: wholeCellStack.leadingAnchor),
            campaignHeaderView.trailingAnchor.constraint(equalTo: wholeCellStack.trailingAnchor),
            campaignHeaderView.topAnchor.constraint(equalTo: wholeCellStack.topAnchor),
            campaignHeaderView.heightAnchor.constraint(equalTo: wholeCellStack.heightAnchor,multiplier: 0.25)
        ]
        
        // Collection View Set Up - Constraints
        let feedCollectionConstraints = [
            feedCollection.leadingAnchor.constraint(equalTo: wholeCellStack.leadingAnchor),
            feedCollection.trailingAnchor.constraint(equalTo: wholeCellStack.trailingAnchor),
            feedCollection.bottomAnchor.constraint(equalTo: wholeCellStack.bottomAnchor),

        ]
        
        // Cell Stack Set Up - Constraints
        let wholeCellStackConstraints = [
            wholeCellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wholeCellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wholeCellStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            wholeCellStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        ]
        
        campaignHeaderView.addSubview(campaignIcon)
        campaignHeaderView.addSubview(campaignInfoStackView)
        contentView.addSubview(wholeCellStack)
        
        
        NSLayoutConstraint.activate(wholeCellStackConstraints)
        NSLayoutConstraint.activate(feedCollectionConstraints)
        NSLayoutConstraint.activate(headerViewConstraints)
        NSLayoutConstraint.activate(infoStackViewConstraints)
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(iconConstraints)


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with campaignItem: CampaignItem) {
        self.campaignItem = campaignItem
        campaignNameLabel.text = campaignItem.campaignName
        
        let attribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let payPerInstallString = NSMutableAttributedString(string: campaignItem.campaignPayPerInstall, attributes: attribute)
        payPerInstallString.append(NSMutableAttributedString(string: " per install"))
        
        payPerInstallLabel.attributedText = payPerInstallString
        
        guard let campaignIconUrl = URL(string: campaignItem.campaignImageLink) else { return }
        NetworkUtils.getImageFromURL(imageUrl: campaignIconUrl) { [weak self] (image, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("There was an error: ", error)
            }
            else {
                strongSelf.campaignIcon.image = image
            }
        }
        feedCollection.reloadData()
    }
    
}
// MARK: - Collection View Delegate methods
extension CampaignCollectionViewCell:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaignItem?.campaignMedia.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = feedCollection.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
        if let mediaItem = campaignItem?.campaignMedia[indexPath.item] {
            cell.configure(with: mediaItem)
        }
        else {
            print("Media item could not be found at index:", indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.0, height: collectionView.frame.height)
    }
    
}
