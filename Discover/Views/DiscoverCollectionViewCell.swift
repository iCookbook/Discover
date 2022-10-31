//
//  DiscoverCollectionViewCell.swift
//  Discover
//
//  Created by Егор Бадмаев on 31.10.2022.
//

import UIKit
import Resources
/// Used for providing `identifier` property for register and dequeing cell.
import CommonUI
import Models

enum DiscoverCollectionViewCellType: Int {
    case usual
    case dishOfTheDay
    case usualWithSeparateTitle
}

final class DiscoverCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private var type: DiscoverCollectionViewCellType = .usual
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.sampleRecipeImage
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = Colors.transparentTitleLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recipeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recipeTertiaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Colors.transparentTitleLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView(for: type)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.backgroundColor = Colors.systemGroupedBackground
        [recipeImageView, recipeTitleLabel, recipeSubtitleLabel, recipeTertiaryLabel].forEach {
            contentView.addSubview($0)
        }
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    private func setupView(for type: DiscoverCollectionViewCellType) {
        switch type {
        case .usual:
            recipeSubtitleLabel.isHidden = false
            recipeTertiaryLabel.isHidden = false
            
            NSLayoutConstraint.deactivate(dishOfTheDayConstraints)
            NSLayoutConstraint.deactivate(usualWithSeparateTitleConstraints)
            NSLayoutConstraint.activate(usualConstraints)
        case .dishOfTheDay:
            let dishOfTheDayLabel = UILabel()
            dishOfTheDayLabel.textColor = .white
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            let recipesDescriptionLabel = UILabel()
            recipesDescriptionLabel.layer.zPosition = 1
            recipesDescriptionLabel.textColor = .white
            
            contentView.addSubview(blurEffectView)
            contentView.addSubview(recipesDescriptionLabel)
            
            recipeSubtitleLabel.isHidden = true
            recipeTertiaryLabel.isHidden = true
            
            NSLayoutConstraint.deactivate(usualConstraints)
            NSLayoutConstraint.activate(dishOfTheDayConstraints)
        case .usualWithSeparateTitle:
            recipeTertiaryLabel.isHidden = true
            
            NSLayoutConstraint.deactivate(usualConstraints)
            NSLayoutConstraint.deactivate(dishOfTheDayConstraints)
            NSLayoutConstraint.activate(usualWithSeparateTitleConstraints)
        }
    }
    
    // MARK: - Public Methods
    
    public func configure(with data: Recipe?, for type: DiscoverCollectionViewCellType) {
        self.type = type
        recipeTitleLabel.text = data?.label
        recipeSubtitleLabel.text = data?.source
        let totalTime = data?.totalTime != 0.0 ? Int(data?.totalTime ?? 50.0) : 50
        let yield = data?.yield != 0.0 ? Int(data?.yield ?? 4.0) : 4
        recipeTertiaryLabel.text = "Время приготовления: \(totalTime) минут, количество порций: \(yield)"
    }
}

private extension DiscoverCollectionViewCell {
    var usualConstraints: [NSLayoutConstraint] {
        [recipeImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
         recipeImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
         recipeImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
         recipeImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
         
         recipeSubtitleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: contentView.layoutMargins.top),
         recipeSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: contentView.layoutMargins.left),
         recipeSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -contentView.layoutMargins.right),
         
         recipeTitleLabel.topAnchor.constraint(equalTo: recipeSubtitleLabel.bottomAnchor, constant: contentView.layoutMargins.bottom / 2),
         recipeTitleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: contentView.layoutMargins.left),
         recipeTitleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -contentView.layoutMargins.right),
         
         recipeTertiaryLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -contentView.layoutMargins.bottom),
         recipeTertiaryLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: contentView.layoutMargins.left),
         recipeTertiaryLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -contentView.layoutMargins.right)]
    }
    
    var dishOfTheDayConstraints: [NSLayoutConstraint] {
        [recipeTitleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: contentView.layoutMargins.bottom),
         recipeTitleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: contentView.layoutMargins.left),
         recipeTitleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -contentView.layoutMargins.right),
         
         recipeImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
         recipeImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
         recipeImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
         recipeImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)]
    }
    
    var usualWithSeparateTitleConstraints: [NSLayoutConstraint] {
        [recipeSubtitleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: contentView.layoutMargins.top),
         recipeSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: contentView.layoutMargins.left),
         recipeSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -contentView.layoutMargins.right),
         
         recipeTitleLabel.topAnchor.constraint(equalTo: recipeSubtitleLabel.bottomAnchor, constant: contentView.layoutMargins.bottom / 5),
         recipeTitleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: contentView.layoutMargins.left),
         recipeTitleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -contentView.layoutMargins.right),
         
         recipeImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 80),
         recipeImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
         recipeImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
         recipeImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)]
    }
}
