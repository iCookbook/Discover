//
//  DiscoverViewController.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Common
import CommonUI
import Resources

final class DiscoverViewController: BaseRecipesViewController {
    
    // MARK: - Private Properties
    
    /// Refresh control to implement _pull to refresh_
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lightGray
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return refreshControl
    }()
    
    /// Offline mode views.
    private let largeIconImageView = UIImageView(image: Images.Discover.network)
    private let emptyCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.Discover.emptyCollectionViewText
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var offlineStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [largeIconImageView, emptyCollectionLabel])
        stackView.spacing = 24
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.requestRandomData()
    }
    
    override func resetAllActivity() {
        super.resetAllActivity()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        // removes text from back button's title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = Texts.Discover.title
        view.backgroundColor = Colors.systemBackground
        
        view.addSubview(recipesCollectionView)
        recipesCollectionView.addSubview(refreshControl)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -view.layoutMargins.top * 3),
            
            recipesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recipesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recipesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recipesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func handleRefreshControl() {
        presenter.requestRandomData()
    }
    
    override func turnOnOfflineMode() {
        view.addSubview(offlineStackView)
        
        NSLayoutConstraint.activate([
            offlineStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.layoutMargins.left),
            offlineStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.layoutMargins.right),
            offlineStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            offlineStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
        ])
    }
}

// MARK: - DiscoverViewInput

extension DiscoverViewController: DiscoverViewInput {
}

// MARK: - Collection View

extension DiscoverViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row % 3 {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as? RecipeCollectionViewCell else {
                fatalError("Could not cast cell at indexPath \(indexPath) to 'UsualCollectionViewCell' in 'Discover' module")
            }
            cell.configure(with: data[indexPath.row])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeRecipeCollectionViewCell.identifier, for: indexPath) as? LargeRecipeCollectionViewCell else {
                fatalError("Could not cast cell at indexPath \(indexPath) to 'LargeRecipeCollectionViewCell' in 'Discover' module")
            }
            cell.configure(with: data[indexPath.row], dishOfTheDayLabelIsHidden: false)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsualCollectionViewCell.identifier, for: indexPath) as? UsualCollectionViewCell else {
                fatalError("Could not cast cell at indexPath \(indexPath) to 'UsualBCollectionViewCell' in 'Discover' module")
            }
            cell.configure(with: data[indexPath.row])
            return cell
        default:
            fatalError("Unexpected value in switch: \(indexPath.row % 3)")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// We need to check that it is not a setup (first launch, when `collectionView.contentOffset.y == 0` and make usual check for the end of the collection (scroll) view.
        if (recipesCollectionView.contentOffset.y != 0 &&
            recipesCollectionView.contentOffset.y >= (recipesCollectionView.contentSize.height - recipesCollectionView.bounds.size.height)) {
            /// Fetcing should not be in progress and there should be valid next page url.
            guard !isFetchingInProgress,
                  let nextPageUrl = nextPageUrl,
                  let presenter = presenter as? DiscoverViewOutput
            else { return }
            
            isFetchingInProgress = true
            /// Because it is _event handling_, we need to use `userInteractive` quality of service.
            DispatchQueue.global(qos: .userInteractive).async {
                presenter.requestData(urlString: nextPageUrl)
            }
        }
    }
    
    // MARK: Footer
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionViewFooter.identifier, for: indexPath) as? LoadingCollectionViewFooter else {
                fatalError("Could not cast to `LoadingCollectionViewFooter` for indexPath \(indexPath) in viewForSupplementaryElementOfKind")
            }
            return footer
        default:
            // empty view
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
        case UICollectionView.elementKindSectionFooter:
            guard let footer = view as? LoadingCollectionViewFooter else {
                fatalError("Could not cast to `LoadingCollectionViewFooter` for indexPath \(indexPath) in willDisplaySupplementaryView")
            }
            /// If there is link to the next page, start loading.
            if nextPageUrl != nil {
                footer.startActivityIndicator()
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
        case UICollectionView.elementKindSectionFooter:
            guard let footer = view as? LoadingCollectionViewFooter else {
                fatalError("Could not cast to `LoadingCollectionViewFooter` for indexPath \(indexPath) in didEndDisplayingSupplementaryView")
            }
            footer.stopActivityIndicator()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        /// If there is link to the next page, set size for footer, if not, set size for small inset.
        if nextPageUrl != nil {
            return CGSize(width: view.frame.size.width, height: 80)
        } else {
            return CGSize(width: view.frame.size.width, height: 20)
        }
    }
}
