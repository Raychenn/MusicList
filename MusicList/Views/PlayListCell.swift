//
//  PlayListCell.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/14.
//

import UIKit

class PlayListCell: UICollectionViewCell {
    
    // MARK: - Initial
    
    var artworkImageViewBottomConstraint: NSLayoutConstraint?
    
    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
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
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "4:15"
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "long description:  here is description, pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long. pretty long."
        return label
    }()
    
    private let playStatusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
       let stack = UIStackView(arrangedSubviews: [
            trackNameLabel,
            spacerView,
            trackTimeLabel
       ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        artworkImageView.image = nil
        trackNameLabel.text = nil
        trackTimeLabel.text = nil
        descriptionLabel.text = nil
        playStatusLabel.text = nil 
    }
    
    // MARK: - Helper
    
    private func setupUI() {
        contentView.addSubview(playStatusLabel)
        playStatusLabel.anchor(top: contentView.topAnchor,
                                left: contentView.leadingAnchor,
                                paddingTop: 32,
                                paddingLeft: 26)
        
        contentView.addSubview(hStack)
        hStack.anchor(top: contentView.topAnchor,
                      left: contentView.leadingAnchor,
                      right: contentView.trailingAnchor,
                      paddingTop: 10,
                      paddingLeft: 138,
                      paddingRight: 20)
        
        contentView.addSubview(artworkImageView)
        artworkImageView.translatesAutoresizingMaskIntoConstraints = false
        artworkImageView.setDimensions(height: 100, width: 100)
        artworkImageView.anchor(top: contentView.topAnchor,
                                left: contentView.leadingAnchor,
                                paddingTop: 72,
                                paddingLeft: 10)
        
        artworkImageViewBottomConstraint = artworkImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -72)
        artworkImageViewBottomConstraint?.isActive = true
    
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: artworkImageView.topAnchor,
                                left: artworkImageView.trailingAnchor,
                                right: contentView.trailingAnchor,
                                paddingLeft: 18)
        let descriptionLabelBottomConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22)
        descriptionLabelBottomConstraint.priority = .required
        descriptionLabelBottomConstraint.isActive = true
    }
    
    func configure(with viewModel: PlayListCellViewModel) {
        artworkImageView.loadImageUsingCache(withUrl: viewModel.artworkURLString ?? "",
                                             placeHolder: UIImage(resource: .artwork))
        
        trackNameLabel.text = viewModel.trackName
        
        trackTimeLabel.text = viewModel.trackTime
        
        if let description = viewModel.description {
            descriptionLabel.text = viewModel.description
        } else {
            artworkImageViewBottomConstraint?.isActive = false
        }
        
        playStatusLabel.text = viewModel.playStatusText
    }
    
    func updatePlayStatus(with text: String?) {
        playStatusLabel.text = text
        layoutIfNeeded()
    }
}
