//
//  DiscoverViewController.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Resources
import Models
import CommonUI

final class DiscoverViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let output: DiscoverViewOutput
    /// Link to the next page.
    private var nextPageUrl: String?
    /// Array of recipes.
    private var data: [Recipe] = []
    /// Defines whether fetching is in progress. It is being used for pagination.
    private var isFetchingInProgress = false
    
    /// Refresh control to implement _pull to refresh_
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return refreshControl
    }()
    
    /// Activity indicator for displaying loading.
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    /// Collection view with recipes.
    private lazy var recipeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width - 32, height: view.frame.size.height * 0.38)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.addSubview(refreshControl)
        collectionView.register(UsualCollectionViewCell.self, forCellWithReuseIdentifier: UsualCollectionViewCell.identifier)
        collectionView.register(UsualBCollectionViewCell.self, forCellWithReuseIdentifier: UsualBCollectionViewCell.identifier)
        collectionView.register(LargeRecipeCollectionViewCell.self, forCellWithReuseIdentifier: LargeRecipeCollectionViewCell.identifier)
        collectionView.register(LoadingCollectionViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionViewFooter.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    
    init(output: DiscoverViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        output.requestRandomData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        title = Texts.Discover.title
        view.backgroundColor = Colors.systemBackground
        view.addSubview(recipeCollectionView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            
            recipeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recipeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recipeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recipeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func handleRefreshControl() {
        output.requestRandomData()
    }
}

extension DiscoverViewController: DiscoverViewInput {
    func fillData(with data: [Recipe], nextPageUrl: String?, withOverridingCurrentData: Bool) {
        if withOverridingCurrentData {
            // first setup or pull to refresh
            self.data = data
        } else {
            // pagination
            self.data.append(contentsOf: data)
        }
        self.nextPageUrl = nextPageUrl
        
        DispatchQueue.main.async {
            // no need to put self in capture list, because DispatchQueue does not capture self
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.isFetchingInProgress = false
            UIView.transition(with: self.recipeCollectionView, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
                recipeCollectionView.reloadData()
            })
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            print("❗️Alert:", title, message)
        }
    }
}

// MARK: - UICollectionView

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row % 3 {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsualCollectionViewCell.identifier, for: indexPath) as? UsualCollectionViewCell else {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsualBCollectionViewCell.identifier, for: indexPath) as? UsualBCollectionViewCell else {
                fatalError("Could not cast cell at indexPath \(indexPath) to 'UsualBCollectionViewCell' in 'Discover' module")
            }
            cell.configure(with: data[indexPath.row])
            return cell
        default:
            fatalError("Unexpected value in switch: \(indexPath.row % 3)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.didSelectRecipe(data[indexPath.row])
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 1.4, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// We need to check that it is not a setup (first launch, when `collectionView.contentOffset.y == 0` and make usual check for the end of the collection (scroll) view.
        if (recipeCollectionView.contentOffset.y != 0 &&
            recipeCollectionView.contentOffset.y >= (recipeCollectionView.contentSize.height - recipeCollectionView.bounds.size.height)) {
            /// Fetcing should not be in progress and there should be valid next page url.
            guard !isFetchingInProgress,
                  let nextPageUrl = nextPageUrl else { return }
            isFetchingInProgress = true
            output.requestData(urlString: nextPageUrl)
        }
    }
    
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
