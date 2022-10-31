//
//  DiscoverViewController.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Resources

final class DiscoverViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let output: DiscoverViewOutput
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width - view.layoutMargins.left * 2, height: view.frame.size.height * 0.2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        title = Texts.Discover.title
        view.backgroundColor = Colors.systemBackground
        
        output.requestData()
    }
}

extension DiscoverViewController: DiscoverViewInput {
}
