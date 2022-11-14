//
//  DiscoverAssembly.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Networking

public final class DiscoverAssembly {
    
    // MARK: - Public Properties
    
    public let input: DiscoverModuleInput
    public let viewController: UIViewController
    
    // MARK: - Private Properties
    
    private(set) weak var router: DiscoverRouterInput!
    
    // MARK: - Public Methods
    
    public static func assemble(with context: DiscoverContext) -> DiscoverAssembly {
        let router = DiscoverRouter()
        let interactor = DiscoverInteractor(networkManager: context.moduleDependency)
        let presenter = DiscoverPresenter(router: router, interactor: interactor)
        let viewController = DiscoverViewController(presenter: presenter)
        
        presenter.view = viewController
        presenter.moduleOutput = context.moduleOutput
        
        interactor.presenter = presenter
        router.viewController = viewController
        
        return DiscoverAssembly(view: viewController, input: presenter, router: router)
    }
    
    // MARK: - Init
    
    private init(view: UIViewController, input: DiscoverModuleInput, router: DiscoverRouterInput) {
        self.viewController = view
        self.input = input
        self.router = router
    }
}

public struct DiscoverContext {
    weak var moduleOutput: DiscoverModuleOutput?
    let moduleDependency: NetworkManagerProtocol
    
    public init(moduleOutput: DiscoverModuleOutput? = nil, moduleDependency: NetworkManagerProtocol) {
        self.moduleOutput = moduleOutput
        self.moduleDependency = moduleDependency
    }
}
