//
//  DiscoverPresenter.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Foundation

final class DiscoverPresenter {
    weak var view: DiscoverViewInput?
    weak var moduleOutput: DiscoverModuleOutput?
    
    // MARK: - Private Properties
    
    private let router: DiscoverRouterInput
    private let interactor: DiscoverInteractorInput
    
    // MARK: - Init
    
    init(router: DiscoverRouterInput, interactor: DiscoverInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension DiscoverPresenter: DiscoverModuleInput {
}

extension DiscoverPresenter: DiscoverViewOutput {
}

extension DiscoverPresenter: DiscoverInteractorOutput {
}
