//
//  PlayListCell.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/14.
//

import UIKit

class PlayListCell: UICollectionViewCell {
    
    // MARK: - Initial
    
    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .artwork)
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "long track name long long long longlonglonglonlong track name long long long longlonglonglonlong track name long long long longlonglonglon"
        return label
    }()
    
    private let trackTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "4:15"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "long description:  here is description, pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long."
        return label
    }()
    
    private let playStatusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "正在播放 ▶️"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .red
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    private func setupUI() {
        contentView.addSubview(playStatusLabel)
        playStatusLabel.anchor(top: contentView.topAnchor,
                                left: contentView.leadingAnchor,
                                paddingTop: 32,
                                paddingLeft: 26)
        
        contentView.addSubview(trackNameLabel)
        trackNameLabel.anchor(top: contentView.topAnchor,
                              left: contentView.leadingAnchor,
                          paddingTop: 22,
                          paddingLeft: 138)
        
        contentView.addSubview(trackTimeLabel)
        trackTimeLabel.centerYAnchor.constraint(equalTo: trackNameLabel.centerYAnchor).isActive = true
        trackTimeLabel.anchor(left: trackNameLabel.trailingAnchor,
                              right: contentView.trailingAnchor,
                              paddingLeft: 10,
                              paddingRight: 40)
        
        contentView.addSubview(artworkImageView)
        artworkImageView.setDimensions(height: 100, width: 100)
        artworkImageView.anchor(top: playStatusLabel.bottomAnchor,
                                left: contentView.leadingAnchor,
                                paddingTop: 10,
                                paddingLeft: 10)
    
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: artworkImageView.topAnchor,
                                left: artworkImageView.trailingAnchor,
                                bottom: contentView.bottomAnchor,
                                right: contentView.trailingAnchor,
                                paddingLeft: 18, paddingBottom: 22)
    }
}
