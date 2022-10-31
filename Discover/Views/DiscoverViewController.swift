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

final class DiscoverViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let output: DiscoverViewOutput
    /// Array of recipes to show.
    private var data: [Recipe]?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width - 32, height: view.frame.size.height * 0.38)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        collectionView.register(UsualCollectionViewCell.self, forCellWithReuseIdentifier: UsualCollectionViewCell.identifier)
        collectionView.register(UsualBCollectionViewCell.self, forCellWithReuseIdentifier: UsualBCollectionViewCell.identifier)
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
        output.requestData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        title = Texts.Discover.title
        view.backgroundColor = Colors.systemBackground
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DiscoverViewController: DiscoverViewInput {
    func fillData(with data: [Recipe]) {
        self.data = data
        
        DispatchQueue.main.async {
            // no need to put self in capture list, because DispatchQueue does not capture self
            self.collectionView.reloadData()
        }
    }
    
    func showAlert(title: String, message: String) {
        print("❗️Alert:", title, message)
    }
}

// MARK: - UICollectionView

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row % 2 {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsualCollectionViewCell.identifier, for: indexPath) as? UsualCollectionViewCell else {
                fatalError("Could not cast 'UICollectionViewCell' to 'UsualCollectionViewCell' in 'Discover' module")
            }
            cell.configure(with: data?[indexPath.row])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsualBCollectionViewCell.identifier, for: indexPath) as? UsualBCollectionViewCell else {
                fatalError("Could not cast 'UICollectionViewCell' to 'UsualBCollectionViewCell' in 'Discover' module")
            }
            cell.configure(with: data?[indexPath.row])
            return cell
        default:
            fatalError("Unexpected value in switch: \(indexPath.row % 2)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipe = data?[indexPath.row] else { return }
        output.didSelectRecipe(recipe)
    }
}
